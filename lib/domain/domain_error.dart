final class DomainError implements Exception {
  const DomainError({required this.type, required this.message, this.stackTrace});

  factory DomainError.fromException({required Exception e, StackTrace? stackTrace}) {
    return DomainError.unknown(e: e, stackTrace: stackTrace);
  }

  factory DomainError.unknown({required Exception e, StackTrace? stackTrace}) =>
      DomainError(type: DomainErrorType.unknown, message: e.toString(), stackTrace: stackTrace);

  final DomainErrorType type;
  final String message;
  final StackTrace? stackTrace;

  @override
  String toString() => 'DomainError: $message';
}

enum DomainErrorType { unknown }
