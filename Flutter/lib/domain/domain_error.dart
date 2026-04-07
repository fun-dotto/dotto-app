import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';

final class DomainError implements Exception {
  const DomainError({
    required this.type,
    required this.message,
    this.stackTrace,
  });

  factory DomainError.fromException({
    required Exception e,
    StackTrace? stackTrace,
  }) {
    if (e is DioException) {
      return DomainError._fromDioException(e: e, stackTrace: stackTrace);
    }
    if (e is FirebaseException) {
      return DomainError._fromFirebaseException(e: e, stackTrace: stackTrace);
    }
    return DomainError.unknown(e: e, stackTrace: stackTrace);
  }

  factory DomainError._fromDioException({
    required DioException e,
    StackTrace? stackTrace,
  }) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return DomainError.network(e: e, stackTrace: stackTrace);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode != null) {
          if (statusCode == 401) {
            return DomainError.unauthorized(e: e, stackTrace: stackTrace);
          }
          if (statusCode == 403) {
            return DomainError.forbidden(e: e, stackTrace: stackTrace);
          }
          if (statusCode == 404) {
            return DomainError.notFound(e: e, stackTrace: stackTrace);
          }
          if (statusCode >= 500) {
            return DomainError.server(e: e, stackTrace: stackTrace);
          }
        }
        return DomainError.invalidResponse(e: e, stackTrace: stackTrace);
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return DomainError.network(e: e, stackTrace: stackTrace);
    }
  }

  factory DomainError._fromFirebaseException({
    required FirebaseException e,
    StackTrace? stackTrace,
  }) {
    switch (e.code) {
      case 'unavailable':
      case 'deadline-exceeded':
        return DomainError.network(e: e, stackTrace: stackTrace);
      case 'not-found':
        return DomainError.notFound(e: e, stackTrace: stackTrace);
      case 'permission-denied':
        return DomainError.forbidden(e: e, stackTrace: stackTrace);
      case 'unauthenticated':
        return DomainError.unauthorized(e: e, stackTrace: stackTrace);
      case 'internal':
      case 'data-loss':
        return DomainError.server(e: e, stackTrace: stackTrace);
      case 'invalid-argument':
      case 'failed-precondition':
      case 'out-of-range':
        return DomainError.invalidData(e: e, stackTrace: stackTrace);
      default:
        return DomainError.unknown(e: e, stackTrace: stackTrace);
    }
  }

  factory DomainError.network({required Exception e, StackTrace? stackTrace}) =>
      DomainError(
        type: DomainErrorType.network,
        message: e.toString(),
        stackTrace: stackTrace,
      );

  factory DomainError.server({required Exception e, StackTrace? stackTrace}) =>
      DomainError(
        type: DomainErrorType.server,
        message: e.toString(),
        stackTrace: stackTrace,
      );

  factory DomainError.notFound({
    required Exception e,
    StackTrace? stackTrace,
  }) => DomainError(
    type: DomainErrorType.notFound,
    message: e.toString(),
    stackTrace: stackTrace,
  );

  factory DomainError.invalidResponse({
    required Exception e,
    StackTrace? stackTrace,
  }) => DomainError(
    type: DomainErrorType.invalidResponse,
    message: e.toString(),
    stackTrace: stackTrace,
  );

  factory DomainError.unauthorized({
    required Exception e,
    StackTrace? stackTrace,
  }) => DomainError(
    type: DomainErrorType.unauthorized,
    message: e.toString(),
    stackTrace: stackTrace,
  );

  factory DomainError.forbidden({
    required Exception e,
    StackTrace? stackTrace,
  }) => DomainError(
    type: DomainErrorType.forbidden,
    message: e.toString(),
    stackTrace: stackTrace,
  );

  factory DomainError.invalidData({
    required Exception e,
    StackTrace? stackTrace,
  }) => DomainError(
    type: DomainErrorType.invalidData,
    message: e.toString(),
    stackTrace: stackTrace,
  );

  factory DomainError.unknown({required Exception e, StackTrace? stackTrace}) =>
      DomainError(
        type: DomainErrorType.unknown,
        message: e.toString(),
        stackTrace: stackTrace,
      );

  final DomainErrorType type;
  final String message;
  final StackTrace? stackTrace;

  @override
  String toString() => 'DomainError: $message';
}

enum DomainErrorType {
  network,
  server,
  notFound,
  invalidResponse,
  unauthorized,
  forbidden,
  invalidData,
  unknown,
}
