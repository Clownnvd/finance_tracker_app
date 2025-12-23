import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'exceptions.dart';

class ExceptionMapper {
  static AppException map(dynamic e) {
    if (e is AppException) return e;
    if (e is SocketException) return const NetworkException('No internet connection');
    if (e is TimeoutException) return const TimeoutRequestException();
    if (e is DioException) return _dio(e);
    return AppException(e.toString());
  }

  static AppException _dio(DioException e) {
    final s = e.response?.statusCode;
    final d = e.response?.data;
    final m = _msg(d) ?? e.message ?? 'Request failed';

    if (s == 400 || s == 401 || s == 403) return AuthException(m);
    if (s != null && s >= 500) return ServerException(m);
    return ServerException(m);
  }

  static String? _msg(dynamic d) {
    if (d is String && d.trim().isNotEmpty) return d.trim();
    if (d is Map<String, dynamic>) {
      for (final k in ['msg', 'error_description', 'message', 'error', 'error_code', 'code']) {
        final v = d[k]?.toString().trim();
        if (v != null && v.isNotEmpty) return v;
      }
    }
    return null;
  }
}
