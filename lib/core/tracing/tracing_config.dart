/// Central configuration for end-to-end request tracing.
///
/// The tracing headers (`X-Session-Id`, `X-Trace-Id`, `X-Request-Id`) are
/// attached ONLY to requests whose target host is listed in [allowedHosts]
/// and are never sent to third-party URLs.
///
/// All IDs here are logging labels only — they are never used for
/// authentication and never contain PII.
class TracingConfig {
  TracingConfig._();

  // ---------------------------------------------------------------------------
  // Header names — part of the backend contract, do not rename.
  // ---------------------------------------------------------------------------

  /// Session id: minted at login, stable for the whole login session.
  static const String sessionIdHeader = 'X-Session-Id';

  /// Trace id: one user action (e.g. "tap Pay") that may span several calls.
  static const String traceIdHeader = 'X-Trace-Id';

  /// Request id: a fresh UUID for every individual HTTP call (incl. retries).
  static const String requestIdHeader = 'X-Request-Id';

  // ---------------------------------------------------------------------------
  // Session policy
  // ---------------------------------------------------------------------------

  /// How long the app must be inactive (left in the background) before the
  /// session id is rotated. Checked on app resume by [SessionService].
  static const Duration sessionInactivityTimeout = Duration(minutes: 30);

  /// Hosts that receive the tracing headers. Add staging/dev hosts here as
  /// needed, e.g. `TracingConfig.allowedHosts.add('staging.msysconsultgh.com')`.
  ///
  /// Matching is an exact, case-insensitive host name comparison (scheme and
  /// port are not considered).
  static final Set<String> allowedHosts = <String>{'app.msysconsultgh.com'};

  /// True when [uri] points at one of the configured backend hosts.
  static bool isBackendHost(Uri uri) {
    final String host = uri.host.toLowerCase();
    if (host.isEmpty) return false;
    return allowedHosts.any((String allowed) => allowed.toLowerCase() == host);
  }

  // ---------------------------------------------------------------------------
  // Keys used in RequestOptions.extra (internal plumbing, visible in logs)
  // ---------------------------------------------------------------------------

  /// Client-generated request id for the current attempt.
  static const String extraRequestId = 'tracing.request_id';

  /// Trace id resolved for the current attempt (explicit > zone > fresh).
  static const String extraTraceId = 'tracing.trace_id';

  /// Final request id for a failed call: server-provided when available,
  /// otherwise the client-generated one.
  static const String extraResolvedRequestId = 'tracing.resolved_request_id';

  /// Wall-clock start time of the request (milliseconds since epoch).
  static const String extraStartedAt = 'tracing.started_at_ms';

  /// Optional key a caller may set in `Options(extra: {...})` to force a
  /// specific trace id, e.g. `Options(extra: {'traceId': myTraceId})`.
  /// Takes precedence over the enclosing [Trace.run] zone value.
  static const String explicitTraceIdExtra = 'traceId';

  /// Capacity of the in-memory log ring buffer exposed by [AppLogger.buffer]
  /// for "report a problem" attachments.
  static const int logBufferCapacity = 200;
}
