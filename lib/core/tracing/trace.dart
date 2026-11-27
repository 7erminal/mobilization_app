import 'dart:async';

import 'package:uuid/uuid.dart';

import 'app_logger.dart';

/// Zone-based trace scope for user actions.
///
/// A "trace" represents ONE user action (e.g. "tap Pay") that may trigger
/// several HTTP calls. Every call made inside [run] automatically reuses the
/// same `X-Trace-Id` — including retries that happen inside the block — so
/// the backend can correlate them.
///
/// ```dart
/// Trace.run('pay', () async {
///   await ApiFetcher.instance.deposit(...);   // same X-Trace-Id
///   await ApiFetcher.instance.accountBalance(...); // same X-Trace-Id
/// });
/// ```
///
/// Calls made outside any trace simply get a fresh trace id per request.
/// Nested `Trace.run` blocks: the innermost one wins for its subtree.
class Trace {
  Trace._();

  static const String _traceIdKey = 'tracing.zone.trace_id';
  static const String _traceNameKey = 'tracing.zone.trace_name';

  static const Uuid _uuid = Uuid();

  /// Runs [action] under a fresh trace id. The id is generated once per
  /// [run] call and stored as a zone value, so it propagates through
  /// `await`s, futures and retries started inside [action] without touching
  /// any call sites.
  static R run<R>(String name, R Function() action) {
    final String traceId = _uuid.v4();
    // Note: no "finished" log here — for async actions this method returns
    // as soon as the Future is created, long before the action completes.
    // The HTTP interceptor logs every call with the trace id instead.
    AppLogger.d('TRACE "$name" started ($traceId)');
    return runZoned<R>(
      action,
      zoneValues: <Object, Object>{
        _traceIdKey: traceId,
        _traceNameKey: name,
      },
    );
  }

  /// Trace id of the innermost enclosing [Trace.run], or null when the
  /// current code runs outside any trace.
  static String? get currentTraceId => Zone.current[_traceIdKey] as String?;

  /// Name of the innermost enclosing [Trace.run], or null.
  static String? get currentTraceName =>
      Zone.current[_traceNameKey] as String?;
}
