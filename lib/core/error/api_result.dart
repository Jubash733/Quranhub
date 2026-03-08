import 'package:dio/dio.dart';

sealed class ApiResult<T> {
  const ApiResult();
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  final Exception? exception;

  const Failure({
    required this.message,
    this.statusCode,
    this.exception,
  });

  factory Failure.fromException(Exception e) {
    if (e is DioException) {
      return Failure(
        message: _handleDioError(e),
        statusCode: e.response?.statusCode,
        exception: e,
      );
    }
    return Failure(
      message: e.toString(),
      exception: e,
    );
  }

  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return "Connection timeout. Please check your internet connection.";
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            return "Bad request. Please check your input.";
          case 401:
            return "Unauthorized. Please login again.";
          case 403:
            return "Forbidden. You don't have permission to access this resource.";
          case 404:
            return "Not found.";
          case 500:
            return "Internal server error. Please try again later.";
          default:
            return "Received invalid status code: $statusCode";
        }
      case DioExceptionType.cancel:
        return "Request to API server was cancelled";
      case DioExceptionType.connectionError:
        return "Connection error. Please check your internet connection.";
      case DioExceptionType.unknown:
        return "Unexpected error occurred.";
      default:
        return "Something went wrong.";
    }
  }
}
