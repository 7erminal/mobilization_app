import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

import '../tracing/tracing_config.dart';
import '../tracing/tracing_interceptor.dart';

abstract class Exceptions {
  static String errorMessage(dynamic e, {String? server}) {
    if (e is TimeoutException) {
      return 'Looks like the server is taking to long to respond.';
    }

    if (e is DioError) {
      if (e.error is SocketException) {
        return e.error.toString().replaceAll("SocketException: ", "");
      }

      final statusCode = e.response?.statusCode;

      switch (statusCode) {
        case 400:
          return 'Looks like you have an unstable network at the moment';
        case 403:
          return 'Forbidden';
        case 404:
          return 'Request page not found';
        default:
          return 'Cannot connect to server${server ?? e.toString().substring(0, e.toString().length < 30 ? e.toString().length : 30)}';
      }
    } else {
      return e.toString().substring(0, e.toString().length < 30 ? e.toString().length : 30);
    }
  }

  /// Returns the request id of a failed HTTP call, or null when unknown.
  ///
  /// Precedence: the id resolved by [TracingInterceptor] (server body →
  /// server response header → client-generated id) → re-parse of
  /// `error.request_id` from the response body → `X-Request-Id` response
  /// header. Purely a logging label, never used for auth.
  static String? extractRequestId(dynamic e) {
    if (e is DioException) {
      final Object? resolved =
          e.requestOptions.extra[TracingConfig.extraResolvedRequestId];
      if (resolved is String && resolved.isNotEmpty) return resolved;
      return extractErrorRequestId(e.response?.data) ??
          e.response?.headers.value(TracingConfig.requestIdHeader);
    }
    return null;
  }
}
