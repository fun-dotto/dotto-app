final class DomainError implements Exception {
  const DomainError({required this.type, required this.message, this.stackTrace});

  factory DomainError.fromException({required Exception e, StackTrace? stackTrace}) {
    return DomainError.unknown(e: e, stackTrace: stackTrace);
  }

  factory DomainError.network({required Exception e, StackTrace? stackTrace}) =>
      DomainError(type: DomainErrorType.network, message: e.toString(), stackTrace: stackTrace);

  factory DomainError.server({required Exception e, StackTrace? stackTrace}) =>
      DomainError(type: DomainErrorType.server, message: e.toString(), stackTrace: stackTrace);

  factory DomainError.notFound({required Exception e, StackTrace? stackTrace}) =>
      DomainError(type: DomainErrorType.notFound, message: e.toString(), stackTrace: stackTrace);

  factory DomainError.invalidResponse({required Exception e, StackTrace? stackTrace}) =>
      DomainError(type: DomainErrorType.invalidResponse, message: e.toString(), stackTrace: stackTrace);

  factory DomainError.unauthorized({required Exception e, StackTrace? stackTrace}) =>
      DomainError(type: DomainErrorType.unauthorized, message: e.toString(), stackTrace: stackTrace);

  factory DomainError.forbidden({required Exception e, StackTrace? stackTrace}) =>
      DomainError(type: DomainErrorType.forbidden, message: e.toString(), stackTrace: stackTrace);

  factory DomainError.invalidData({required Exception e, StackTrace? stackTrace}) =>
      DomainError(type: DomainErrorType.invalidData, message: e.toString(), stackTrace: stackTrace);

  factory DomainError.unknown({required Exception e, StackTrace? stackTrace}) =>
      DomainError(type: DomainErrorType.unknown, message: e.toString(), stackTrace: stackTrace);

  final DomainErrorType type;
  final String message;
  final StackTrace? stackTrace;

  @override
  String toString() => 'DomainError: $message';
}

enum DomainErrorType { network, server, notFound, invalidResponse, unauthorized, forbidden, invalidData, unknown }
