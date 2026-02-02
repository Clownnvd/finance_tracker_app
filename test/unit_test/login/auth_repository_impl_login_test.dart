import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/network/session_local_data_source.dart';
import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';

import 'package:finance_tracker_app/feature/users/auth/data/models/auth_remote_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/data/repositories/auth_repository_impl.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockSessionLocalDataSource extends Mock
    implements SessionLocalDataSource {}

class MockUserIdLocalDataSource extends Mock implements UserIdLocalDataSource {}

class FakeCancelToken extends Fake implements CancelToken {}

void main() {
  late MockAuthRemoteDataSource remote;
  late MockSessionLocalDataSource sessionLocal;
  late MockUserIdLocalDataSource userIdLocal;
  late AuthRepositoryImpl repo;

  const email = 'test@example.com';
  const password = '12345678';
  const testTokens = AuthTokens(
    accessToken: 'access_token_123',
    refreshToken: 'refresh_token_456',
    expiresAt: 1700000000,
  );

  setUpAll(() {
    registerFallbackValue(FakeCancelToken());
  });

  setUp(() {
    remote = MockAuthRemoteDataSource();
    sessionLocal = MockSessionLocalDataSource();
    userIdLocal = MockUserIdLocalDataSource();

    // Default stubs for side effects
    when(() => sessionLocal.saveAccessToken(any())).thenAnswer((_) async {});
    when(() => sessionLocal.saveRefreshToken(any())).thenAnswer((_) async {});
    when(() => sessionLocal.saveExpiresAt(any())).thenAnswer((_) async {});
    when(() => userIdLocal.saveUserId(any())).thenAnswer((_) async {});

    repo = AuthRepositoryImpl(
      remote: remote,
      sessionLocal: sessionLocal,
      userIdLocal: userIdLocal,
    );
  });

  test('login returns UserModel and saves tokens when remote success',
      () async {
    when(() => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => testTokens);

    when(() => remote.getMe(cancelToken: any(named: 'cancelToken')))
        .thenAnswer((_) async => {
              'id': 'u1',
              'email': email,
              'user_metadata': {'full_name': 'Test User'},
            });

    final result = await repo.login(email: email, password: password);

    expect(result,
        const UserModel(id: 'u1', email: email, fullName: 'Test User'));

    verify(() => remote.login(
          email: email,
          password: password,
          cancelToken: null,
        )).called(1);

    verify(() => sessionLocal.saveAccessToken(testTokens.accessToken))
        .called(1);
    verify(() => sessionLocal.saveRefreshToken(testTokens.refreshToken))
        .called(1);
    verify(() => sessionLocal.saveExpiresAt(testTokens.expiresAt)).called(1);

    verify(() => remote.getMe(cancelToken: null)).called(1);
    verify(() => userIdLocal.saveUserId('u1')).called(1);
  });

  test('login throws AuthException when remote.login throws AuthException',
      () async {
    when(() => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          cancelToken: any(named: 'cancelToken'),
        )).thenThrow(const AuthException('Invalid credentials'));

    await expectLater(
      repo.login(email: email, password: password),
      throwsA(isA<AuthException>()),
    );

    verify(() => remote.login(
          email: email,
          password: password,
          cancelToken: null,
        )).called(1);

    verifyNever(() => sessionLocal.saveAccessToken(any()));
    verifyNever(() => sessionLocal.saveRefreshToken(any()));
    verifyNever(() => sessionLocal.saveExpiresAt(any()));
    verifyNever(() => remote.getMe(cancelToken: any(named: 'cancelToken')));
    verifyNever(() => userIdLocal.saveUserId(any()));
  });

  test(
      'login throws NetworkException when remote.login throws NetworkException',
      () async {
    when(() => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          cancelToken: any(named: 'cancelToken'),
        )).thenThrow(const NetworkException('No internet connection'));

    await expectLater(
      repo.login(email: email, password: password),
      throwsA(isA<NetworkException>()),
    );

    verify(() => remote.login(
          email: email,
          password: password,
          cancelToken: null,
        )).called(1);

    verifyNever(() => sessionLocal.saveAccessToken(any()));
    verifyNever(() => remote.getMe(cancelToken: any(named: 'cancelToken')));
    verifyNever(() => userIdLocal.saveUserId(any()));
  });

  test(
      'login throws TimeoutRequestException when remote.login throws TimeoutRequestException',
      () async {
    when(() => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          cancelToken: any(named: 'cancelToken'),
        )).thenThrow(const TimeoutRequestException('Request timed out'));

    await expectLater(
      repo.login(email: email, password: password),
      throwsA(isA<TimeoutRequestException>()),
    );

    verify(() => remote.login(
          email: email,
          password: password,
          cancelToken: null,
        )).called(1);

    verifyNever(() => sessionLocal.saveAccessToken(any()));
    verifyNever(() => remote.getMe(cancelToken: any(named: 'cancelToken')));
    verifyNever(() => userIdLocal.saveUserId(any()));
  });

  test('login throws AuthException when remote.getMe throws AuthException',
      () async {
    when(() => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => testTokens);

    when(() => remote.getMe(cancelToken: any(named: 'cancelToken')))
        .thenThrow(const AuthException('Token expired'));

    await expectLater(
      repo.login(email: email, password: password),
      throwsA(isA<AuthException>()),
    );

    verify(() => remote.login(
          email: email,
          password: password,
          cancelToken: null,
        )).called(1);

    // Tokens saved before getMe fails
    verify(() => sessionLocal.saveAccessToken(testTokens.accessToken))
        .called(1);
    verify(() => sessionLocal.saveRefreshToken(testTokens.refreshToken))
        .called(1);
    verify(() => sessionLocal.saveExpiresAt(testTokens.expiresAt)).called(1);

    verify(() => remote.getMe(cancelToken: null)).called(1);

    // When _fetchMe fails, user id must not be saved
    verifyNever(() => userIdLocal.saveUserId(any()));
  });
}
