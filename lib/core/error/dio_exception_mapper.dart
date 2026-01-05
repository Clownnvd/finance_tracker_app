import 'package:dio/dio.dart';

import 'exceptions.dart';

/// Maps DioException to domain-specific [AppException].
///
/// Centralizes HTTP status handling & error message extraction
/// to avoid magic numbers and duplicated logic.
class DioExceptionMapper {
  const DioExceptionMapper._(); // no instance

  static AppException map(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;
    final message = _extractMessage(data) ??
        e.message ??
        'Request failed';

    if (_isAuthError(statusCode)) {
      return AuthException(message);
    }

    if (_isValidationError(statusCode)) {
      return ValidationException(message);
    }

    if (_isServerError(statusCode)) {
      return ServerException(message);
    }

    return ServerException(message);
  }

  // =======================
  // Status helpers
  // =======================

  static bool _isAuthError(int? statusCode) {
    return statusCode == _HttpStatus.unauthorized ||
        statusCode == _HttpStatus.forbidden;
  }

  static bool _isValidationError(int? statusCode) {
    return statusCode == _HttpStatus.badRequest;
  }

  static bool _isServerError(int? statusCode) {
    return statusCode != null && statusCode >= _HttpStatus.serverError;
  }

  // =======================
  // Message extraction
  // =======================

  static String? _extractMessage(dynamic data) {
    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }

    if (data is Map) {
      for (final key in _ErrorKeys.priorityOrder) {
        final value = data[key]?.toString().trim();
        if (value != null && value.isNotEmpty) {
          return value;
        }
      }
    }

    return null;
  }
}

/// HTTP status constants (local to network layer).
/// Keeps magic numbers out of business logic.
class _HttpStatus {
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int serverError = 500;
}

/// Known backend error keys (priority-based).
class _ErrorKeys {
  static const List<String> priorityOrder = [
    'msg',
    'message',
    'error_description',
    'error',
    'error_code',
    'code',
  ];
}
