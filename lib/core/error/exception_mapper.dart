import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'exceptions.dart';

class ExceptionMapper {
  static AppException map(dynamic error) {
    if (error is AppException) return error;

    if (error is SocketException) {
      return const NetworkException('No internet connection');
    }

    if (error is TimeoutException) {
      return const TimeoutRequestException();
    }

    if (error is DioException) {
      return _mapDio(error);
    }

    return AppException(error.toString());
  }

  static AppException _mapDio(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    final msg = _extractSupabaseMessage(data) ??
        _extractGenericMessage(data) ??
        e.message ??
        'Request failed';

    // 400/401/403: auth/validation hay gặp ở Supabase Auth
    if (status == 400 || status == 401 || status == 403) {
      return AuthException(msg);
    }

    if (status != null && status >= 500) {
      return ServerException(msg);
    }

    // Không rõ status thì vẫn trả msg thật thay vì "Unexpected server error"
    return ServerException(msg);
  }

  static String? _extractSupabaseMessage(dynamic data) {
    // Supabase thường trả: { code, error_code, msg }
    // hoặc: { error, error_description }
    if (data is Map<String, dynamic>) {
      final candidates = [
        data['msg'],
        data['error_description'],
        data['message'],
        data['error'],
        data['error_code'],
        data['code'],
      ];
      for (final c in candidates) {
        final s = c?.toString().trim();
        if (s != null && s.isNotEmpty) return s;
      }
    }
    return null;
  }

  static String? _extractGenericMessage(dynamic data) {
    if (data is String && data.trim().isNotEmpty) return data.trim();
    return null;
  }
}
