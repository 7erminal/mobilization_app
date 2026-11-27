import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  /// Request id for the failed call (`error.request_id` from the server,
  /// falling back to the `X-Request-Id` response header, or the
  /// client-generated id when no response arrived). Surfaced on error UI as
  /// "Reference: <short id>" so support can correlate logs. Null when
  /// unknown. Logging label only — never used for auth, no PII.
  final String? requestId;

  const Failure({required this.message, this.requestId});

  @override
  List<Object?> get props => [message, requestId];

  @override
  String toString() {
    return message;
  }
}

class ServerFailure extends Failure {
  const ServerFailure({required String message, String? requestId})
      : super(message: message, requestId: requestId);
}
