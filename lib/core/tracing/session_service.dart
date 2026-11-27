import 'package:uuid/uuid.dart';

import 'app_logger.dart';
import 'tracing_config.dart';

/// Why the session id was rotated. Logging label only.
enum SessionRotationReason { logout, inactivityTimeout }

/// Owns the tracing session id (`X-Session-Id`).
///
/// Lifecycle:
///  - successful login → [startSession] mints a fresh UUID (this also covers
///    "login as a different user", because logout always precedes it);
///  - logout → [endSession] clears it — pre-login requests carry no session
///    header, matching the contract ("generated when the user logs in");
///  - the app left in the background for at least
///    [TracingConfig.sessionInactivityTimeout] → [markResumed] rotates it.
///
/// The session id is an in-memory logging label: it is never persisted,
/// never used for authentication, and contains no PII.
class SessionService {
  SessionService({DateTime Function()? now, Uuid? uuid})
      : _now = now ?? DateTime.now,
        _uuid = uuid ?? const Uuid();

  final DateTime Function() _now;
  final Uuid _uuid;

  String? _sessionId;
  DateTime? _backgroundedAt;

  /// Crash-reporting context: ids of the most recent backend request/trace.
  /// Attach these when reporting errors to a crash service.
  String? lastRequestId;
  String? lastTraceId;

  String? get sessionId => _sessionId;

  bool get hasSession => _sessionId != null;

  /// Mints a fresh session id. Call after a successful login.
  /// Returns the new session id.
  String startSession() {
    _sessionId = _uuid.v4();
    _backgroundedAt = null;
    AppLogger.i('Session started (${TracingConfig.sessionIdHeader}: $_sessionId)');
    return _sessionId!;
  }

  /// Clears the session id (rotation happens on the next login).
  /// Safe to call when no session exists.
  void endSession(SessionRotationReason reason) {
    if (_sessionId == null) {
      AppLogger.d('Session already absent, nothing to rotate ($reason)');
      return;
    }
    AppLogger.i('Session rotated ($reason); next id will be minted at login');
    _sessionId = null;
    _backgroundedAt = null;
  }

  /// The app went to the background. Records the time; called by
  /// [SessionLifecycleObserver] (see auth_bloc.dart).
  void markBackgrounded() {
    _backgroundedAt ??= _now();
  }

  /// The app came back to the foreground. Rotates the session id when the
  /// app was inactive for at least [TracingConfig.sessionInactivityTimeout].
  void markResumed() {
    final DateTime? at = _backgroundedAt;
    _backgroundedAt = null;
    if (at == null) return;

    final Duration away = _now().difference(at);
    if (away >= TracingConfig.sessionInactivityTimeout && _sessionId != null) {
      AppLogger.i(
        'Session rotated (inactivityTimeout): app was away '
        '${away.inMinutes} min (>= ${TracingConfig.sessionInactivityTimeout.inMinutes} min)',
      );
      _sessionId = null;
    }
  }
}
