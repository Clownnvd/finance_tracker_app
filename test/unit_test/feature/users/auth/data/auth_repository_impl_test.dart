import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/network/session_local_data_source.dart';
import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';

import 'package:finance_tracker_app/feature/users/auth/data/models/auth_remote_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/data/repositories/auth_repository_impl.dart';

class MockRemote extends Mock implements AuthRemoteDataSource {}

class MockSession extends Mock implements SessionLocalDataSource {}

class MockUserIdLocal extends Mock implements UserIdLocalDataSource {}

class FakeCancelToken extends Fake implements CancelToken {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCancelToken());
  });

  group('AuthRepositoryImpl', () {
    test('login saves tokens then fetches me and saves userId', () async {
      final remote = MockRemote();
      final session = MockSession();
      final userIdLocal = MockUserIdLocal();

      const testTokens = AuthTokens(
        accessToken: 'token123',
        refreshToken: 'refresh456',
        expiresAt: 1700000000,
      );

      // Default stubs for side effects
      when(() => session.saveAccessToken(any())).thenAnswer((_) async {});
      when(() => session.saveRefreshToken(any())).thenAnswer((_) async {});
      when(() => session.saveExpiresAt(any())).thenAnswer((_) async {});
      when(() => userIdLocal.saveUserId(any())).thenAnswer((_) async {});

      when(() => remote.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => testTokens);

      when(() => remote.getMe(cancelToken: any(named: 'cancelToken')))
          .thenAnswer((_) async => {
                'id': '1',
                'email': 'a@b.com',
                'user_metadata': {'full_name': 'A'},
              });

      final repo = AuthRepositoryImpl(
        remote: remote,
        sessionLocal: session,
        userIdLocal: userIdLocal,
      );

      final user = await repo.login(email: 'a@b.com', password: '12345678');

      expect(user.id, '1');
      expect(user.email, 'a@b.com');

      verify(() => session.saveAccessToken(testTokens.accessToken)).called(1);
      verify(() => session.saveRefreshToken(testTokens.refreshToken)).called(1);
      verify(() => session.saveExpiresAt(testTokens.expiresAt)).called(1);
      verify(() => remote.getMe(cancelToken: null)).called(1);
      verify(() => userIdLocal.saveUserId('1')).called(1);
    });
  });
}
