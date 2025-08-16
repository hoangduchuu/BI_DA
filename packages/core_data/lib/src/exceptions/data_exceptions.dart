class DataException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  const DataException(
    this.message, {
    this.code,
    this.originalException,
  });

  @override
  String toString() => 'DataException: $message${code != null ? ' (code: $code)' : ''}';
}

class NetworkException extends DataException {
  const NetworkException(String message, {String? code, dynamic originalException})
      : super(message, code: code, originalException: originalException);
}

class AuthException extends DataException {
  const AuthException(String message, {String? code, dynamic originalException})
      : super(message, code: code, originalException: originalException);
}

class ValidationException extends DataException {
  const ValidationException(String message, {String? code, dynamic originalException})
      : super(message, code: code, originalException: originalException);
}

class NotFoundException extends DataException {
  const NotFoundException(String message, {String? code, dynamic originalException})
      : super(message, code: code, originalException: originalException);
}
