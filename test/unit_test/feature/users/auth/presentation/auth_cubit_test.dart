import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/login.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/sign_up.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';

class MockLogin extends Mock implements Login {}

class MockSignup extends Mock implements Signup {}

class _FakeCancelToken extends Fake implements CancelToken {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeCancelToken());
  });

  group('AuthCubit', () {
    blocTest<AuthCubit, AuthState>(
  'emits [Loading(1/2), Loading(2/2), Failure] on timeout with retry',
  build: () {
    final login = MockLogin();
    final signup = MockSignup();

    when(() => login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          cancelToken: any(named: 'cancelToken'),
        )).thenThrow(const NetworkException('Timeout'));

    return AuthCubit(login: login, signup: signup);
  },
  act: (cubit) => cubit.login('a@b.com', '12345678'),
  expect: () => [
    isA<AuthLoading>()
        .having((s) => s.attempt, 'attempt', 1)
        .having((s) => s.maxAttempts, 'maxAttempts', 2),
    isA<AuthLoading>()
        .having((s) => s.attempt, 'attempt', 2)
        .having((s) => s.maxAttempts, 'maxAttempts', 2),
    isA<AuthFailure>()
        .having((s) => s.message, 'message', isNotEmpty),
  ],
);



    blocTest<AuthCubit, AuthState>(
      'emits [Loading, Success] on success',
      build: () {
        final login = MockLogin();
        final signup = MockSignup();

        when(() => login(
              email: any(named: 'email'),
              password: any(named: 'password'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer(
          (_) async => const UserModel(
            id: '1',
            email: 'a@b.com',
            fullName: 'A',
          ),
        );

        return AuthCubit(login: login, signup: signup);
      },
      act: (cubit) => cubit.login('a@b.com', '12345678'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>().having((s) => s.user.email, 'email', 'a@b.com'),
      ],
    );
  });
}
