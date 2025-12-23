import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/network/session_local_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/data/models/auth_remote_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/data/repositories/auth_repository_impl.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockSessionLocalDataSource extends Mock implements SessionLocalDataSource {}

void main() {
  late MockAuthRemoteDataSource remote;
  late MockSessionLocalDataSource sessionLocal;
  late AuthRepositoryImpl repo;

  setUp(() {
    remote = MockAuthRemoteDataSource();
    sessionLocal = MockSessionLocalDataSource();

    repo = AuthRepositoryImpl(
      remote: remote,
      sessionLocal: sessionLocal,
    );
  });

  const email = 'test@example.com';
  const password = 'Password123';
  const fullName = 'Test User';

  final meJson = <String, dynamic>{
    'id': 'user-1',
    'email': email,
    'user_metadata': {'full_name': fullName},
  };

  final expectedUser = UserModel(
    id: 'user-1',
    email: email,
    fullName: fullName,
  );

  group('signup', () {
    test(
      'signup success (no email confirm) returns UserModel (signup -> login -> saveToken -> getMe)',
      () async {
        // ✅ remote.signup returns SignUpResult
        when(
          () => remote.signup(
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => const SignUpResult(emailConfirmationRequired: false),
        );

        // remote.login returns access_token
        when(
          () => remote.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => 'access-token-123');

        // save token
        when(() => sessionLocal.saveAccessToken(any()))
            .thenAnswer((_) async {});

        // getMe returns user json
        when(() => remote.getMe()).thenAnswer((_) async => meJson);

        final result = await repo.signup(
          email: email,
          password: password,
          fullName: fullName,
        );

        expect(result, expectedUser);

        verify(
          () => remote.signup(
            fullName: fullName,
            email: email,
            password: password,
          ),
        ).called(1);

        verify(() => remote.login(email: email, password: password)).called(1);

        verify(() => sessionLocal.saveAccessToken('access-token-123')).called(1);

        verify(() => remote.getMe()).called(1);

        verifyNoMoreInteractions(remote);
        verifyNoMoreInteractions(sessionLocal);
      },
    );

    test(
      'signup requires email verification -> throws AuthException and does not login',
      () async {
        when(
          () => remote.signup(
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => const SignUpResult(
            emailConfirmationRequired: true,
            message:
                'Sign up successful. Please verify your email before logging in.',
          ),
        );

        expect(
          () => repo.signup(email: email, password: password, fullName: fullName),
          throwsA(isA<AuthException>()),
        );

        verify(
          () => remote.signup(
            fullName: fullName,
            email: email,
            password: password,
          ),
        ).called(1);

        verifyNever(() => remote.login(email: any(named: 'email'), password: any(named: 'password')));
        verifyNever(() => sessionLocal.saveAccessToken(any()));
        verifyNever(() => remote.getMe());
      },
    );

    test('signup remote throws AuthException -> rethrow and does not login', () async {
      when(
        () => remote.signup(
          fullName: any(named: 'fullName'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AuthException('Email exists'));

      expect(
        () => repo.signup(email: email, password: password, fullName: fullName),
        throwsA(isA<AuthException>()),
      );

      verify(
        () => remote.signup(fullName: fullName, email: email, password: password),
      ).called(1);

      verifyNever(() => remote.login(email: any(named: 'email'), password: any(named: 'password')));
      verifyNever(() => sessionLocal.saveAccessToken(any()));
      verifyNever(() => remote.getMe());
    });
  });

  group('login', () {
    test('login success returns UserModel (login -> saveToken -> getMe)', () async {
      when(
        () => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => 'access-token-xyz');

      when(() => sessionLocal.saveAccessToken(any()))
          .thenAnswer((_) async {});
      when(() => remote.getMe()).thenAnswer((_) async => meJson);

      final result = await repo.login(email: email, password: password);

      expect(result, expectedUser);

      verify(() => remote.login(email: email, password: password)).called(1);
      verify(() => sessionLocal.saveAccessToken('access-token-xyz')).called(1);
      verify(() => remote.getMe()).called(1);
    });

    test('login error throws AuthException', () async {
      when(
        () => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AuthException('Invalid login credentials'));

      expect(
        () => repo.login(email: email, password: password),
        throwsA(isA<AuthException>()),
      );

      verify(() => remote.login(email: email, password: password)).called(1);
      verifyNever(() => sessionLocal.saveAccessToken(any()));
      verifyNever(() => remote.getMe());
    });
  });

  group('logout', () {
    test('logout clears session token', () async {
      when(() => sessionLocal.clear()).thenAnswer((_) async {});

      await repo.logout();

      verify(() => sessionLocal.clear()).called(1);
      verifyNoMoreInteractions(sessionLocal);
    });
  });
}
