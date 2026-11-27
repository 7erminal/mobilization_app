import 'package:logger/logger.dart';

import 'tracing_config.dart';

/// Release mode flag without importing Flutter, so the tracing core stays
/// pure Dart. Defined exactly like package:flutter does it.
const bool _kReleaseMode = bool.fromEnvironment('dart.vm.product');

/// Matches `Bearer <token>` (JWTs, opaque tokens, ...).
final RegExp _bearerPattern =
    RegExp(r'Bearer\s+[\w\-._~+/]+=*', caseSensitive: false);

/// Matches `sensitiveKey: value` / `sensitiveKey=value` pairs. Values that
/// are already the `Bearer ***` marker (see [_bearerPattern]) are left
/// alone, so the marker survives one redaction pass.
final RegExp _sensitiveKeyValuePattern = RegExp(
  r'(\bauthorization\b|\brefresh[-_ ]?token\b|\baccess[-_ ]?token\b|\btoken\b|'
  r'\bpassword\b|\bpin\b|\bsecret\b)'
  r'\s*[:=]\s*'
  r'("(?:[^"\\]|\\.)*"|(?!Bearer\s*\*\*\*)[^\s,;}]+)',
  caseSensitive: false,
);

/// Strips credentials from a log line. Values for keys such as
/// `Authorization`, `token`, `password`, `pin`, `secret` are replaced with
/// `***` before the line reaches the console or the log buffer.
String redact(String message) {
  String out = message.replaceAll(_bearerPattern, 'Bearer ***');
  out = out.replaceAllMapped(
    _sensitiveKeyValuePattern,
    (Match m) => '${m.group(1)}: ***',
  );
  return out;
}

/// In-memory ring buffer holding the last [capacity] log lines (redacted,
/// no request bodies or PII). A "Report a problem" action can attach
/// `AppLogger.buffer.snapshot()` to a report. No UI is built for it here.
class LogBuffer {
  LogBuffer({this.capacity = TracingConfig.logBufferCapacity});

  final int capacity;
  final List<String> _lines = <String>[];

  void append(String line) {
    _lines.add(line);
    if (_lines.length > capacity) {
      _lines.removeRange(0, _lines.length - capacity);
    }
  }

  /// Immutable copy of the buffered lines, oldest first.
  List<String> snapshot() => List<String>.unmodifiable(_lines);

  void clear() => _lines.clear();

  int get length => _lines.length;
}

/// Single-line printer: writes a compact line to the console and mirrors it
/// (redacted, one line per event) into the [LogBuffer].
class _BufferingPrinter extends LogPrinter {
  _BufferingPrinter(this._buffer);

  final LogBuffer _buffer;

  static const Map<Level, String> _labels = <Level, String>{
    Level.trace: 'TRACE',
    Level.debug: 'DEBUG',
    Level.info: 'INFO',
    Level.warning: 'WARN',
    Level.error: 'ERROR',
    Level.fatal: 'FATAL',
  };

  @override
  List<String> log(LogEvent event) {
    final String label =
        _labels[event.level] ?? event.level.name.toUpperCase();
    final DateTime time = event.time.toLocal();
    final String hh = time.hour.toString().padLeft(2, '0');
    final String mm = time.minute.toString().padLeft(2, '0');
    final String ss = time.second.toString().padLeft(2, '0');
    final String ms = time.millisecond.toString().padLeft(3, '0');
    final String message = redact(event.message?.toString() ?? '');
    final String line = '$label $hh:$mm:$ss.$ms $message';

    final List<String> consoleLines = <String>[line];
    if (event.error != null) {
      consoleLines.add('  error: ${redact(event.error.toString())}');
    }

    // Buffer keeps one redacted line per event (no stack traces).
    final String bufferedLine = event.error != null
        ? '$line | error: ${redact(event.error.toString())}'
        : line;
    _buffer.append(bufferedLine);

    // Stack traces help debugging on the console but are never buffered.
    if (event.stackTrace != null) {
      consoleLines.addAll(event.stackTrace.toString().split('\n'));
    }
    return consoleLines;
  }
}

/// Debug builds log everything (verbose); release builds keep only
/// info/warning/error lines.
class _BuildModeFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (_kReleaseMode) {
      return event.level.value >= Level.info.value;
    }
    return true;
  }
}

/// App-wide logger. Use [d] for verbose/debug output (debug builds only),
/// and [i]/[w]/[e] for concise output that also shows in release builds.
class AppLogger {
  AppLogger._();

  /// Ring buffer of the last ~200 log lines for "report a problem".
  static final LogBuffer buffer =
      LogBuffer(capacity: TracingConfig.logBufferCapacity);

  static final Logger _logger = Logger(
    filter: _BuildModeFilter(),
    printer: _BufferingPrinter(buffer),
  );

  /// Debug/verbose — only emitted in debug builds.
  static void d(String message) => _logger.d(message);

  /// Info — emitted in debug and release builds.
  static void i(String message) => _logger.i(message);

  /// Warning — emitted in debug and release builds.
  static void w(String message, {Object? error}) =>
      _logger.w(message, error: error);

  /// Error — emitted in debug and release builds.
  static void e(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
