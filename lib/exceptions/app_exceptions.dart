// app_exception.dart

// Base class for custom exceptions
class AppException implements Exception {
  final String message;
  final String prefix;

  AppException([this.message = "", this.prefix = ""]);

  @override
  String toString() {
    return "$prefix$message";
  }
}

// Exception for network-related errors (e.g., no internet)
class NetworkException extends AppException {
  NetworkException([String message = "Network Error"])
      : super(message, "Network Error: ");
}

// Exception for invalid data format (e.g., wrong JSON format)
class InvalidFormatException extends AppException {
  InvalidFormatException([String message = "Invalid Data Format"])
      : super(message, "Invalid Data Format: ");
}

// Exception for request timeout
class TimeoutException extends AppException {
  TimeoutException([String message = "Request Timed Out"])
      : super(message, "Request Timed Out: ");
}

// Exception for resource not found (404 error)
class ResourceNotFoundException extends AppException {
  ResourceNotFoundException([String message = "Resource Not Found"])
      : super(message, "Error 404: ");
}

// Exception for server-side errors (e.g., 500 error)
class ServerException extends AppException {
  ServerException([String message = "Server Error"])
      : super(message, "Server Error: ");
}



// Exception for forbidden access (403 error)
class ForbiddenException extends AppException {
  ForbiddenException([String message = "Forbidden Access"])
      : super(message, "Error 403: ");
}

// Exception for bad request (400 error)
class BadRequestException extends AppException {
  BadRequestException([String message = "Bad Request"])
      : super(message, "Error 400: ");
}

// Exception for unknown errors
class UnknownException extends AppException {
  UnknownException([String message = "Unknown Error"])
      : super(message, "Unknown Error: ");
}
