import 'package:dio/dio.dart';
import 'exceptions.dart';

Exception handleDioError(DioException exception) {
  final response = exception.response;

  if (response != null) {
    final int statusCode = response.statusCode ?? 0;
    final dynamic data = response.data;

    String? serverMessage;
    if (data is Map<String, dynamic>) {
      serverMessage = data['message']?.toString();
    }

    final finalMessage =
        serverMessage ??
        exception.message ??
        response.statusMessage ??
        "Unknown Error";

    switch (statusCode) {
      case 401:
        return UnauthorizedException("Session expired. Please login again.");
      case 403:
        return ForbiddenException("You don't have permission to do this.");
      case 404:
        return NotFoundException("Resource not found (404).");
      case 422:
        final Map<String, dynamic>? validationErrors =
            (data is Map<String, dynamic>) ? data['errors'] : null;
        return ValidationException(finalMessage, validationErrors);

      case >= 500 && <= 504:
        return ServerException(
          "Server error ($statusCode). Message : $finalMessage . Please try again later.",
        );

      default:
        return AppException("Error $statusCode: $finalMessage");
    }
  }

  return _handleNetworkError(exception);
}

Exception _handleNetworkError(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return AppException("Connection timed out. Please check your internet.");
    case DioExceptionType.connectionError:
      return AppException("No internet connection or server unreachable.");
    case DioExceptionType.cancel:
      return AppException("Request was cancelled.");
    default:
      return AppException("An unexpected network error occurred.");
  }
}
