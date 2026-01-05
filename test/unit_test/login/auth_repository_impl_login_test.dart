import 'package:finance_tracker_app/core/network/session_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/feature/users/auth/data/models/auth_remote_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/data/repositories/auth_repository_impl.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockSessionLocalDataSource extends Mock implements SessionLocalDataSource {}

void main() {
  late MockAuthRemoteDataSource remote;
  late MockSessionLocalDataSource sessionLocal;
  late AuthRepositoryImpl repo;

  const email = 'test@example.com';
  const password = '12345678';
  const token = 'token_abc_123';

  setUp(() {
    remote = MockAuthRemoteDataSource();
    sessionLocal = MockSessionLocalDataSource();
    repo = AuthRepositoryImpl(remote: remote, sessionLocal: sessionLocal);
  });

  test('login returns UserModel and saves access token when remote success', () async {
    when(() => remote.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => token);

    when(() => sessionLocal.saveAccessToken(any())).thenAnswer((_) async {});

    when(() => remote.getMe()).thenAnswer((_) async => {
          'id': 'u1',
          'email': email,
          'user_metadata': {'full_name': 'Test User'},
        });

    final result = await repo.login(email: email, password: password);

    expect(result, const UserModel(id: 'u1', email: email, fullName: 'Test User'));

    verify(() => remote.login(email: any(named: 'email'), password: any(named: 'password'))).called(1);
    verify(() => sessionLocal.saveAccessToken(token)).called(1);
    verify(() => remote.getMe()).called(1);

    verifyNoMoreInteractions(remote);
    verifyNoMoreInteractions(sessionLocal);
  });

  test('login throws AuthException when remote.login throws AuthException', () async {
    when(() => remote.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenThrow(const AuthException('Invalid credentials'));

    await expectLater(
      repo.login(email: email, password: password),
      throwsA(isA<AuthException>()),
    );

    verify(() => remote.login(email: any(named: 'email'), password: any(named: 'password'))).called(1);
    verifyNever(() => sessionLocal.saveAccessToken(any()));
    verifyNever(() => remote.getMe());
  });

  test('login throws NetworkException when remote.login throws NetworkException', () async {
    when(() => remote.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenThrow(const NetworkException('No internet connection'));

    await expectLater(
      repo.login(email: email, password: password),
      throwsA(isA<NetworkException>()),
    );

    verify(() => remote.login(email: any(named: 'email'), password: any(named: 'password'))).called(1);
    verifyNever(() => sessionLocal.saveAccessToken(any()));
    verifyNever(() => remote.getMe());
  });

  test('login throws TimeoutRequestException when remote.login throws TimeoutRequestException', () async {
    when(() => remote.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenThrow(const TimeoutRequestException('Request timed out'));

    await expectLater(
      repo.login(email: email, password: password),
      throwsA(isA<TimeoutRequestException>()),
    );

    verify(() => remote.login(email: any(named: 'email'), password: any(named: 'password'))).called(1);
    verifyNever(() => sessionLocal.saveAccessToken(any()));
    verifyNever(() => remote.getMe());
  });

  test('login throws AuthException when remote.getMe throws AuthException', () async {
    when(() => remote.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => token);

    when(() => sessionLocal.saveAccessToken(any())).thenAnswer((_) async {});

    when(() => remote.getMe()).thenThrow(const AuthException('Token expired'));

    await expectLater(
      repo.login(email: email, password: password),
      throwsA(isA<AuthException>()),
    );

    verify(() => remote.login(email: any(named: 'email'), password: any(named: 'password'))).called(1);
    verify(() => sessionLocal.saveAccessToken(token)).called(1);
    verify(() => remote.getMe()).called(1);
  });
}
