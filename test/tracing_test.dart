import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobilization_app/core/api_services/api_caller.dart';
import 'package:mobilization_app/core/errors/exceptions.dart';
import 'package:mobilization_app/core/errors/failures.dart';
import 'package:mobilization_app/core/tracing/index.dart';

/// Regex for a canonical lowercase UUIDv4.
final RegExp _uuidV4 = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
);

bool _isUuidV4(String? value) => value != null && _uuidV4.hasMatch(value);

String? sentHeader(RequestOptions options, String name) {
  final Object? value = options.headers[name];
  if (value is String) return value;
  if (value is List && value.isNotEmpty) return value.first.toString();
  return null;
}

/// Adapter that records every request it sees and replies with a canned
/// response, so no real network is involved.
class _CapturingAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = <RequestOptions>[];

  ResponseBody Function(RequestOptions options)? responder;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final ResponseBody Function(RequestOptions options)? fn = responder;
    if (fn != null) return fn(options);
    return ResponseBody.fromString(
      jsonEncode(<String, dynamic>{'ok': true}),
      200,
      headers: <String, List<String>>{
        'content-type': <String>['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dio(_CapturingAdapter adapter, {SessionService? sessionService}) {
  final Dio dio = Dio();
  dio.httpClientAdapter = adapter;
  dio.interceptors.add(
    TracingInterceptor(
      sessionService: sessionService ?? SessionService(),
    ),
  );
  return dio;
}

/// Mutable clock for testing the inactivity rotation.
class _Clock {
  _Clock(this.value);
  DateTime value;
}

void main() {
  group('header attachment (backend host)', () {
    test('adds session, trace and request ids to backend requests', () async {
      final _CapturingAdapter adapter = _CapturingAdapter();
      final SessionService session = SessionService()..startSession();
      final Dio dio = _dio(adapter, sessionService: session);

      await dio.post('https://app.msysconsultgh.com/v1/agent/api/deposit');

      expect(adapter.requests, hasLength(1));
      final RequestOptions sent = adapter.requests.single;
      expect(_isUuidV4(sentHeader(sent, TracingConfig.sessionIdHeader)), isTrue,
          reason: 'X-Session-Id must be a UUID');
      expect(_isUuidV4(sentHeader(sent, TracingConfig.traceIdHeader)), isTrue,
          reason: 'X-Trace-Id must be a UUID');
      expect(_isUuidV4(sentHeader(sent, TracingConfig.requestIdHeader)), isTrue,
          reason: 'X-Request-Id must be a UUID');
    });

    test('session id stays the same for the whole login session', () async {
      final _CapturingAdapter adapter = _CapturingAdapter();
      final SessionService session = SessionService()..startSession();
      final Dio dio = _dio(adapter, sessionService: session);

      await dio.post('https://app.msysconsultgh.com/v1/a');
      await dio.post('https://app.msysconsultgh.com/v1/b');

      final String first =
          sentHeader(adapter.requests[0], TracingConfig.sessionIdHeader)!;
      final String second =
          sentHeader(adapter.requests[1], TracingConfig.sessionIdHeader)!;
      expect(first, second);
    });

    test('no session header before login / after logout (rotation)',
        () async {
      final _CapturingAdapter adapter = _CapturingAdapter();
      final SessionService session = SessionService();
      final Dio dio = _dio(adapter, sessionService: session);

      // Pre-login: trace + request ids exist, no session id yet.
      await dio.post('https://app.msysconsultgh.com/v1/pre-login');
      expect(
        sentHeader(adapter.requests[0], TracingConfig.sessionIdHeader),
        isNull,
      );
      expect(
        sentHeader(adapter.requests[0], TracingConfig.traceIdHeader),
        isNotNull,
      );

      final String sessionId = session.startSession();
      await dio.post('https://app.msysconsultgh.com/v1/logged-in');
      expect(
        sentHeader(adapter.requests[1], TracingConfig.sessionIdHeader),
        sessionId,
      );

      // Logout rotates (clears) the session id.
      session.endSession(SessionRotationReason.logout);
      expect(session.hasSession, isFalse);

      // Logging back in mints a NEW session id (different-user case too).
      final String newSessionId = session.startSession();
      expect(newSessionId, isNot(sessionId));
      await dio.post('https://app.msysconsultgh.com/v1/re-login');
      expect(
        sentHeader(adapter.requests[2], TracingConfig.sessionIdHeader),
        newSessionId,
      );
    });

    test('session rotates after the inactivity timeout', () async {
      final _Clock clock =
          _Clock(DateTime(2026, 1, 1, 10, 0, 0));
      final SessionService session = SessionService(now: () => clock.value);
      final String sessionId = session.startSession();

      // Away for 29 minutes: session kept.
      session.markBackgrounded();
      clock.value = clock.value.add(const Duration(minutes: 29));
      session.markResumed();
      expect(session.sessionId, sessionId);

      // Away for another 31 minutes: rotated (cleared).
      session.markBackgrounded();
      clock.value = clock.value.add(const Duration(minutes: 31));
      session.markResumed();
      expect(session.hasSession, isFalse);
      expect(session.sessionId, isNull);

      // A fresh login after rotation must produce a different id.
      expect(session.startSession(), isNot(sessionId));
    });

    test('inactivity rotation shorter than the timeout does not rotate',
        () async {
      final SessionService session = SessionService();
      session.startSession();
      session.markBackgrounded();
      // No time passes (fixed default clock within the same millisecond).
      session.markResumed();
      expect(session.hasSession, isTrue);
    });
  });

  group('trace ids', () {
    test('retries / multiple calls in one Trace.run reuse the trace id '
        'and get a fresh request id each', () async {
      final _CapturingAdapter adapter = _CapturingAdapter();
      final SessionService session = SessionService()..startSession();
      final Dio dio = _dio(adapter, sessionService: session);

      await Trace.run('pay', () async {
        // First attempt...
        await dio.post('https://app.msysconsultgh.com/v1/agent/api/deposit');
        // ...a retry / follow-up call inside the same action.
        await dio.post(
          'https://app.msysconsultgh.com/v1/agent/api/deposit',
        );
      });

      final String? trace1 =
          sentHeader(adapter.requests[0], TracingConfig.traceIdHeader);
      final String? trace2 =
          sentHeader(adapter.requests[1], TracingConfig.traceIdHeader);
      expect(trace1, isNotNull);
      expect(trace1, trace2,
          reason: 'calls of one user action must share the trace id');

      final String? request1 =
          sentHeader(adapter.requests[0], TracingConfig.requestIdHeader);
      final String? request2 =
          sentHeader(adapter.requests[1], TracingConfig.requestIdHeader);
      expect(_isUuidV4(request1), isTrue);
      expect(_isUuidV4(request2), isTrue);
      expect(request1, isNot(request2),
          reason: 'every attempt gets its own request id');
    });

    test('calls outside a trace get a fresh trace id per request', () async {
      final _CapturingAdapter adapter = _CapturingAdapter();
      final Dio dio = _dio(adapter);

      await dio.post('https://app.msysconsultgh.com/v1/a');
      await dio.post('https://app.msysconsultgh.com/v1/b');

      expect(
        sentHeader(adapter.requests[0], TracingConfig.traceIdHeader),
        isNot(sentHeader(adapter.requests[1], TracingConfig.traceIdHeader)),
      );
    });

    test('explicit trace id (extra) wins over the zone value', () async {
      final _CapturingAdapter adapter = _CapturingAdapter();
      final Dio dio = _dio(adapter);

      await Trace.run('outer', () async {
        await dio.post(
          'https://app.msysconsultgh.com/v1/explicit',
          options: Options(
            extra: <String, dynamic>{
              TracingConfig.explicitTraceIdExtra: 'explicit-trace',
            },
          ),
        );
      });

      expect(
        sentHeader(adapter.requests.single, TracingConfig.traceIdHeader),
        'explicit-trace',
      );
    });
  });

  group('non-backend hosts', () {
    test('no tracing headers are sent to third-party hosts', () async {
      final _CapturingAdapter adapter = _CapturingAdapter();
      final SessionService session = SessionService()..startSession();
      final Dio dio = _dio(adapter, sessionService: session);

      await dio.get('https://api.third-party.example.com/v1/thing');

      expect(adapter.requests, hasLength(1));
      final RequestOptions sent = adapter.requests.single;
      expect(sent.headers.containsKey(TracingConfig.sessionIdHeader), isFalse);
      expect(sent.headers.containsKey(TracingConfig.traceIdHeader), isFalse);
      expect(sent.headers.containsKey(TracingConfig.requestIdHeader), isFalse);
    });
  });

  group('failed responses', () {
    test('resolves request id from the error body and exposes it on '
        'ServerFailure', () async {
      final _CapturingAdapter adapter = _CapturingAdapter()
        ..responder = (RequestOptions options) => ResponseBody.fromString(
              jsonEncode(<String, dynamic>{
                'error': <String, dynamic>{
                  'code': 'PAYMENT_FAILED',
                  'message': 'Transaction declined',
                  'request_id': 'srv-req-42',
                },
              }),
              400,
              headers: <String, List<String>>{
                'content-type': <String>['application/json'],
              },
            );
      final Dio dio = _dio(adapter);

      DioException? caught;
      try {
        await dio.post('https://app.msysconsultgh.com/v1/agent/api/deposit');
      } on DioException catch (DioException e) {
        caught = e;
      }
      expect(caught, isNotNull);
      expect(
        caught!.requestOptions.extra[TracingConfig.extraResolvedRequestId],
        'srv-req-42',
      );
      expect(Exceptions.extractRequestId(caught), 'srv-req-42');
    });

    test('falls back to the X-Request-Id response header, then to the '
        'client-generated id when no response arrived', () async {
      // 500 with header only (no contract body).
      final _CapturingAdapter headerOnly = _CapturingAdapter()
        ..responder = (RequestOptions options) => ResponseBody.fromString(
              'oops',
              500,
              headers: <String, List<String>>{
                'x-request-id': <String>['srv-header-id'],
              },
            );
      final Dio dio = _dio(headerOnly);

      DioException? caught;
      try {
        await dio.post('https://app.msysconsultgh.com/v1/x');
      } on DioException catch (DioException e) {
        caught = e;
      }
      expect(Exceptions.extractRequestId(caught), 'srv-header-id');

      // Network failure: no response at all -> client-generated id.
      final _CapturingAdapter offline = _CapturingAdapter()
        ..responder = (RequestOptions options) => throw DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
              error: const SocketException('offline'),
            );
      final Dio dio2 = _dio(offline);

      DioException? networkFailure;
      try {
        await dio2.post('https://app.msysconsultgh.com/v1/x');
      } on DioException catch (DioException e) {
        networkFailure = e;
      }
      expect(networkFailure, isNotNull);
      final String? clientRequestId = sentHeader(
        networkFailure!.requestOptions,
        TracingConfig.requestIdHeader,
      );
      expect(clientRequestId, isNotNull);
      expect(Exceptions.extractRequestId(networkFailure), clientRequestId);
    });

    test('ApisCaller surfaces the server request id on ServerFailure',
        () async {
      ApisCaller.instance.dio.httpClientAdapter = _CapturingAdapter()
        ..responder = (RequestOptions options) => ResponseBody.fromString(
              jsonEncode(<String, dynamic>{
                'error': <String, dynamic>{
                  'code': 'INSUFFICIENT_FUNDS',
                  'message': 'Not enough balance',
                  'request_id': 'srv-req-99',
                },
              }),
              400,
              headers: <String, List<String>>{
                'content-type': <String>['application/json'],
              },
            );

      final dynamic result = await ApisCaller.instance.postData(
        path: 'https://app.msysconsultgh.com/v1/agent/api/deposit',
        builder: (data) => data,
        body: <String, dynamic>{'destination': 'acc-1', 'amount': 10.0},
      );

      expect(result, isA<ServerFailure>());
      expect((result as ServerFailure).requestId, 'srv-req-99');
    });
  });

  group('error body parsing', () {
    test('extractErrorRequestId handles maps, raw JSON and junk', () {
      expect(
        extractErrorRequestId(<String, dynamic>{
          'error': <String, dynamic>{
            'code': 'X',
            'message': 'm',
            'request_id': 'abc-123',
          },
        }),
        'abc-123',
      );
      expect(
        extractErrorRequestId(
          jsonEncode(<String, dynamic>{
            'error': <String, dynamic>{'request_id': 'raw-json-id'},
          }),
        ),
        'raw-json-id',
      );
      expect(extractErrorRequestId(<String, dynamic>{'foo': 1}), isNull);
      expect(extractErrorRequestId('not json'), isNull);
      expect(extractErrorRequestId(null), isNull);
      expect(
        extractErrorRequestId(<String, dynamic>{
          'error': <String, dynamic>{'request_id': ''},
        }),
        isNull,
      );
    });
  });

  group('structured logging', () {
    test('request logging never contains query-string values or tokens',
        () async {
      final _CapturingAdapter adapter = _CapturingAdapter();
      final SessionService session = SessionService()..startSession();
      final Dio dio = _dio(adapter, sessionService: session);

      await dio.get(
        'https://app.msysconsultgh.com/v1/agent/api/account-balance',
        queryParameters: <String, dynamic>{'q': 'SECRETQUERY'},
      );
      AppLogger.d('Authorization: Bearer abc.def.ghi token=supersecret');

      final String buffered = AppLogger.buffer.snapshot().join('\n');
      expect(buffered.contains('SECRETQUERY'), isFalse,
          reason: 'query-string values must never be logged');
      expect(buffered.contains('abc.def.ghi'), isFalse,
          reason: 'bearer tokens must be redacted');
      expect(buffered.contains('supersecret'), isFalse,
          reason: 'token values must be redacted');
      expect(buffered.contains('Bearer ***'), isTrue);
    });

    test('LogBuffer is a bounded ring buffer', () {
      final LogBuffer buffer = LogBuffer(capacity: 3);
      buffer.append('one');
      buffer.append('two');
      buffer.append('three');
      buffer.append('four');
      expect(buffer.snapshot(), <String>['two', 'three', 'four']);
      expect(buffer.length, 3);
      buffer.clear();
      expect(buffer.length, 0);
    });
  });
}
