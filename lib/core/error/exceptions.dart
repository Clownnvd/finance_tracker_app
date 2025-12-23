class AppException implements Exception {
  final String message;
  const AppException(this.message);
  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error. Check connection']);
}

class TimeoutRequestException extends AppException {
  const TimeoutRequestException([super.message = 'Request timed out']);
}

class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed']);
}

class ValidationException extends AppException {
  const ValidationException([super.message = 'Invalid input data']);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred']);
}
class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}