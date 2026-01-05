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

    test('login throws NetworkException on timeout', () async {
      final dio = MockDio();
      final ds = AuthRemoteDataSourceImpl(dio);

      when(() => dio.post(
            any(),
            queryParameters: any(named: 'queryParameters'),
            data: any(named: 'data'),
          )).thenThrow(DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: '/auth/v1/token'),
      ));

      expect(
        () => ds.login(email: 'a@b.com', password: '12345678'),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
