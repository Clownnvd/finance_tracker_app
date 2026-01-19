import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/feature/users/auth/data/models/auth_remote_data_source.dart';

class MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
  });

  group('AuthRemoteDataSourceImpl', () {
    test('login throws ServerException on malformed response (null data)', () async {
      final dio = MockDio();
      final ds = AuthRemoteDataSourceImpl(dio);

      when(() => dio.post(
            any(),
            queryParameters: any(named: 'queryParameters'),
            data: any(named: 'data'),
          )).thenAnswer((_) async => Response(
            data: null,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/v1/token'),
          ));

      expect(
        () => ds.login(email: 'a@b.com', password: '12345678'),
        throwsA(isA<ServerException>()),
      );
    });

    Future<T> _guard<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on DioException catch (e) {
    // ✅ Map timeout-like to NetworkException
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw const NetworkException('Timeout');
    }

    // ✅ Optional: connection error / no internet
    if (e.type == DioExceptionType.connectionError) {
      throw const NetworkException('No internet connection');
    }

    // Everything else => server/unknown
    throw const ServerException('Request failed');
  } catch (_) {
    throw const ServerException('Request failed');
  }
}

  });
}
