import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/network/session_local_data_source.dart';
import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';

import 'package:finance_tracker_app/feature/users/auth/data/models/auth_remote_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/data/repositories/auth_repository_impl.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';

class MockAuthRemoteDataSource extends Mock
    implements AuthRemoteDataSource {}

class MockSessionLocalDataSource extends Mock
    implements SessionLocalDataSource {}

class MockUserIdLocalDataSource extends Mock
    implements UserIdLocalDataSource {}

class FakeCancelToken extends Fake implements CancelToken {}

void main() {
  late MockAuthRemoteDataSource remote;
  late MockSessionLocalDataSource sessionLocal;
  late MockUserIdLocalDataSource userIdLocal;
  late AuthRepositoryImpl repo;

  const email = 'test@example.com';
  const password = 'Password123';
  const fullName = 'Test User';

  final meJson = <String, dynamic>{
    'id': 'user-1',
    'email': email,
    'user_metadata': {'full_name': fullName},
  };

  const expectedUser = UserModel(
    id: 'user-1',
    email: email,
    fullName: fullName,
  );

  setUpAll(() {
    // Required by mocktail when using any(named: ...)
    registerFallbackValue(FakeCancelToken());
  });

  setUp(() {
    remote = MockAuthRemoteDataSource();
    sessionLocal = MockSessionLocalDataSource();
    userIdLocal = MockUserIdLocalDataSource();

    // Common stubs
    when(() => sessionLocal.saveAccessToken(any()))
        .thenAnswer((_) async {});
    when(() => sessionLocal.clear()).thenAnswer((_) async {});
    when(() => userIdLocal.saveUserId(any()))
        .thenAnswer((_) async {});
    when(() => userIdLocal.clear()).thenAnswer((_) async {});

    repo = AuthRepositoryImpl(
      remote: remote,
      sessionLocal: sessionLocal,
      userIdLocal: userIdLocal,
    );
  });

  group('signup', () {
    test(
      'signup success (no email verification) '
      '-> signup -> login -> save token -> getMe -> save userId',
      () async {
        when(() => remote.signup(
              fullName: any(named: 'fullName'),
              email: any(named: 'email'),
              password: any(named: 'password'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer(
          (_) async => const SignUpResult(
            requireEmailVerification: false,
            message: 'Sign up successful.',
          ),
        );

        when(() => remote.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => 'access-token-123');

        when(() => remote.getMe(
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => meJson);

        final result = await repo.signup(
          email: email,
          password: password,
          fullName: fullName,
        );

        expect(result, expectedUser);

        verify(() => remote.signup(
              fullName: fullName,
              email: email,
              password: password,
              cancelToken: null,
            )).called(1);

        verify(() => remote.login(
              email: email,
              password: password,
              cancelToken: null,
            )).called(1);

        verify(() => sessionLocal.saveAccessToken('access-token-123'))
            .called(1);

        verify(() => remote.getMe(cancelToken: null)).called(1);
        verify(() => userIdLocal.saveUserId('user-1')).called(1);
      },
    );

    test(
      'signup requires email verification '
      '-> throws AuthException and does NOT login',
      () async {
        when(() => remote.signup(
              fullName: any(named: 'fullName'),
              email: any(named: 'email'),
              password: any(named: 'password'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer(
          (_) async => const SignUpResult(
            requireEmailVerification: true,
            message: 'Please verify your email.',
          ),
        );

        expect(
          () => repo.signup(
            email: email,
            password: password,
            fullName: fullName,
          ),
          throwsA(isA<AuthException>()),
        );

        verify(() => remote.signup(
              fullName: fullName,
              email: email,
              password: password,
              cancelToken: null,
            )).called(1);

        verifyNever(() => remote.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
              cancelToken: any(named: 'cancelToken'),
            ));

        verifyNever(() => sessionLocal.saveAccessToken(any()));
        verifyNever(() => remote.getMe(cancelToken: any(named: 'cancelToken')));
        verifyNever(() => userIdLocal.saveUserId(any()));
      },
    );
  });

  group('login', () {
    test(
      'login success -> login -> save token -> getMe -> save userId',
      () async {
        when(() => remote.login(
              email: any(named: 'email'),
              password: any(named: 'password'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => 'access-token-xyz');

        when(() => remote.getMe(
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => meJson);

        final result = await repo.login(
          email: email,
          password: password,
        );

        expect(result, expectedUser);

        verify(() => remote.login(
              email: email,
              password: password,
              cancelToken: null,
            )).called(1);

        verify(() => sessionLocal.saveAccessToken('access-token-xyz'))
            .called(1);

        verify(() => remote.getMe(cancelToken: null)).called(1);
        verify(() => userIdLocal.saveUserId('user-1')).called(1);
      },
    );

    test('login throws AuthException -> rethrow', () async {
      when(() => remote.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
            cancelToken: any(named: 'cancelToken'),
          )).thenThrow(const AuthException('Invalid credentials'));

      expect(
        () => repo.login(email: email, password: password),
        throwsA(isA<AuthException>()),
      );

      verifyNever(() => sessionLocal.saveAccessToken(any()));
      verifyNever(() => remote.getMe(cancelToken: any(named: 'cancelToken')));
      verifyNever(() => userIdLocal.saveUserId(any()));
    });
  });

  group('logout', () {
    test('logout clears session and userId', () async {
      await repo.logout();

      verify(() => sessionLocal.clear()).called(1);
      verify(() => userIdLocal.clear()).called(1);
    });
  });
}
