/// Base class for all application-level exceptions.
/// Always contains a message safe to show to UI.
class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

/// Network related issues: no internet, DNS fail, SocketException, etc.
class NetworkException extends AppException {
  const NetworkException([String message = 'Network error. Check connection'])
      : super(message);
}

/// Request timeout or server took too long to respond.
class TimeoutRequestException extends AppException {
  const TimeoutRequestException([String message = 'Request timed out'])
      : super(message);
}

/// Authentication errors: wrong password, invalid email, expired token, etc.
class AuthException extends AppException {
  const AuthException([String message = 'Authentication failed'])
      : super(message);
}

/// Validation errors in client-side or API-side input.
/// (e.g. password too short, email invalid format)
class ValidationException extends AppException {
  const ValidationException([String message = 'Invalid input data'])
      : super(message);
}

/// Server errors (5xx) or unexpected Supabase error messages.
class ServerException extends AppException {
  const ServerException([String message = 'Server error occurred'])
      : super(message);
}
