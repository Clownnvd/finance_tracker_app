import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/error/exception_mapper.dart';

void main() {
  group('ExceptionMapper', () {
    test('maps 401 to AuthException', () {
      final dioError = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: '/'),
        response: Response(
          statusCode: 401,
          data: {'error': 'Unauthorized'},
          requestOptions: RequestOptions(path: '/'),
        ),
      );

      final ex = ExceptionMapper.map(dioError);

      expect(ex, isA<AuthException>());
    });

    test('maps timeout to NetworkException', () {
      final dioError = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: '/'),
      );

      final ex = ExceptionMapper.map(dioError);

      expect(ex, isA<NetworkException>());
    });

    test('maps unknown DioException to AppException', () {
      final dioError = DioException(
        type: DioExceptionType.unknown,
        requestOptions: RequestOptions(path: '/'),
      );

      final ex = ExceptionMapper.map(dioError);

      expect(ex, isA<AppException>());
    });
  });
}
