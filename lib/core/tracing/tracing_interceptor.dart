import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import 'app_logger.dart';
import 'session_service.dart';
import 'trace.dart';
import 'tracing_config.dart';

/// Adds the three tracing headers to every request aimed at a configured
/// backend host ([TracingConfig.allowedHosts]) and emits structured request
/// logs. Requests to third-party hosts pass through untouched.
///
/// Headers set per attempt:
///  - `X-Session-Id`  — current session, absent before login / after logout;
///  - `X-Trace-Id`    — explicit extra (`TracingConfig.explicitTraceIdExtra`)
///                      > enclosing [Trace.run] zone value > fresh UUID;
///  - `X-Request-Id`  — always a fresh UUID for this attempt (retries get a
///                      new one automatically because the interceptor runs
///                      again per attempt).
///
/// On failures, the request id is resolved in this order: `error.request_id`
/// from the response body (backend contract) → `X-Request-Id` response
/// header → the client-generated id. The resolved id is stored in
/// `RequestOptions.extra` under [TracingConfig.extraResolvedRequestId] and
/// surfaced by `Exceptions.extractRequestId`.
///
/// The interceptor only logs method, path (never the query string), status,
/// duration and the IDs — no bodies, no Authorization headers, no PII.
class TracingInterceptor extends Interceptor {
  TracingInterceptor({required this.sessionService, Uuid? uuid})
      : _uuid = uuid ?? const Uuid();

  final SessionService sessionService;
  final Uuid _uuid;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[TracingConfig.extraStartedAt] =
        DateTime.now().millisecondsSinceEpoch;

    if (!TracingConfig.isBackendHost(options.uri)) {
      AppLogger.d(
        'HTTP -> ${options.method} ${options.uri.host}${options.uri.path} '
        '(external host, tracing skipped)',
      );
      handler.next(options);
      return;
    }

    final String requestId = _uuid.v4();
    final String traceId = _resolveTraceId(options);
    final String? sessionId = sessionService.sessionId;

    // Interceptor owns these headers; an explicit header set by a caller
    // still wins so a hand-crafted trace is never clobbered.
    if (options.headers[TracingConfig.traceIdHeader] == null) {
      options.headers[TracingConfig.traceIdHeader] = traceId;
    }
    options.headers[TracingConfig.requestIdHeader] = requestId;
    if (sessionId != null) {
      options.headers[TracingConfig.sessionIdHeader] = sessionId;
    }

    options.extra[TracingConfig.extraRequestId] = requestId;
    options.extra[TracingConfig.extraTraceId] = traceId;
    sessionService.lastRequestId = requestId;
    sessionService.lastTraceId = traceId;

    AppLogger.d(
      'HTTP -> ${options.method} ${options.uri.path} | '
      'session=${sessionId ?? '-'} trace=$traceId request=$requestId',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final RequestOptions options = response.requestOptions;
    final Duration elapsed = _elapsed(options);

    if (!TracingConfig.isBackendHost(options.uri)) {
      AppLogger.d(
        'HTTP <- ${options.method} ${options.uri.path} '
        '${response.statusCode} ${elapsed.inMilliseconds}ms (external)',
      );
      handler.next(response);
      return;
    }

    final String requestId =
        options.extra[TracingConfig.extraRequestId] as String? ?? '-';
    final String traceId =
        options.extra[TracingConfig.extraTraceId] as String? ?? '-';
    final Object? sentSessionRaw = options.headers[TracingConfig.sessionIdHeader];
    final String? sentSession = sentSessionRaw is String ? sentSessionRaw : null;
    final String? echoedRequestId =
        response.headers.value(TracingConfig.requestIdHeader);

    AppLogger.d(
      'HTTP <- ${options.method} ${options.uri.path} '
      '${response.statusCode} ${elapsed.inMilliseconds}ms | '
      'session=${sentSession ?? '-'} trace=$traceId '
      'request=${echoedRequestId ?? requestId}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final RequestOptions options = err.requestOptions;
    final Duration elapsed = _elapsed(options);
    final int? status = err.response?.statusCode;

    if (!TracingConfig.isBackendHost(options.uri)) {
      AppLogger.w(
        'HTTP xx ${options.method} ${options.uri.path} ${err.type.name} '
        '${status ?? 'no response'} ${elapsed.inMilliseconds}ms (external)',
      );
      handler.next(err);
      return;
    }

    // Request id precedence: server body -> server response header ->
    // client-generated id (the fallback for network failures where no
    // response arrived).
    final String? serverBodyId = extractErrorRequestId(err.response?.data);
    final String? serverHeaderId =
        err.response?.headers.value(TracingConfig.requestIdHeader);
    final String? clientId =
        options.extra[TracingConfig.extraRequestId] as String?;
    final String requestId = serverBodyId ?? serverHeaderId ?? clientId ?? '';

    if (requestId.isNotEmpty) {
      options.extra[TracingConfig.extraResolvedRequestId] = requestId;
    }
    final String traceId =
        options.extra[TracingConfig.extraTraceId] as String? ?? '-';
    final Object? sentSessionRaw = options.headers[TracingConfig.sessionIdHeader];
    final String? sentSession = sentSessionRaw is String ? sentSessionRaw : null;

    final String line =
        'HTTP xx ${options.method} ${options.uri.path} ${err.type.name} '
        '${status ?? 'no response'} ${elapsed.inMilliseconds}ms | '
        'session=${sentSession ?? '-'} trace=$traceId '
        'request=${requestId.isEmpty ? '-' : requestId}';
    if (status != null) {
      AppLogger.w(line);
    } else {
      AppLogger.e(line);
    }
    handler.next(err);
  }

  /// Trace id precedence: explicit extra → enclosing [Trace.run] → fresh.
  String _resolveTraceId(RequestOptions options) {
    final Object? explicit =
        options.extra[TracingConfig.explicitTraceIdExtra] ?? Trace.currentTraceId;
    if (explicit is String && explicit.isNotEmpty) return explicit;
    return _uuid.v4();
  }

  Duration _elapsed(RequestOptions options) {
    final Object? started = options.extra[TracingConfig.extraStartedAt];
    if (started is int) {
      return DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(started));
    }
    return Duration.zero;
  }
}

/// Extracts `error.request_id` from a failed response body following the
/// backend contract:
/// `{"error": {"code": "...", "message": "...", "request_id": "..."}}`.
///
/// Accepts an already-decoded JSON [Map] or a raw JSON [String]. Returns
/// null when the body does not follow the contract.
String? extractErrorRequestId(dynamic body) {
  dynamic payload = body;
  if (payload is String && payload.isNotEmpty) {
    try {
      payload = jsonDecode(payload);
    } catch (_) {
      return null;
    }
  }
  if (payload is! Map) return null;

  final Object? error = payload['error'];
  if (error is Map) {
    final Object? id = error['request_id'];
    if (id != null && id.toString().isNotEmpty) return id.toString();
  }
  // Tolerate a flat `request_id` at the top level.
  final Object? flat = payload['request_id'];
  if (flat != null && flat.toString().isNotEmpty) return flat.toString();
  return null;
}
