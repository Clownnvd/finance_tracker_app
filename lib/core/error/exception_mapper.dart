import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'exceptions.dart';

class ExceptionMapper {
  static AppException map(dynamic e) {
    if (e is AppException) return e;
    if (e is DioException) return _mapDioException(e);
    if (e is SocketException) return const NetworkException('No internet connection');
    if (e is TimeoutException) return const TimeoutRequestException();
    return AppException(e.toString());
  }

  static AppException _mapDioException(DioException e) {
    // Handle timeout types
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkException('Connection timeout');
    }

    // Handle bad response with status codes
    if (e.type == DioExceptionType.badResponse && e.response != null) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) {
        return const AuthException('Unauthorized');
      }
      if (statusCode == 403) {
        return const AuthException('Forbidden');
      }
      if (statusCode == 404) {
        return const AppException('Resource not found');
      }
      if (statusCode != null && statusCode >= 500) {
        return const ServerException('Server error');
      }
    }

    // Handle connection errors
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkException('Connection error');
    }

    return AppException(e.message ?? 'Unknown error');
  }
}
