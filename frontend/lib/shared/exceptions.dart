class AppException implements Exception {
  final String message;
  final dynamic details;
  AppException(this.message, [this.details]);

  @override
  String toString() => message;
}

class ValidationException extends AppException {
  ValidationException(super.message, data); // 422
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message); // 401
}

class ForbiddenException extends AppException {
  ForbiddenException(super.message); // 403
}

class NotFoundException extends AppException {
  NotFoundException(super.message); // 404
}

class ServerException extends AppException {
  ServerException(super.message); // 50X
}
