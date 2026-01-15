import 'package:bloc_test/bloc_test.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/sign_up.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/login.dart';


class MockLogin extends Mock implements Login {}
class MockSignup extends Mock implements Signup {}

void main() {
  group('AuthCubit', () {
    blocTest<AuthCubit, AuthState>(
      'emits [Loading, Failure] on timeout',
      build: () {
        final login = MockLogin();
        final signup = MockSignup();

        when(() => login(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(const NetworkException('Timeout'));

        return AuthCubit(
          login: login,
          signup: signup,
        );
      },
      act: (cubit) => cubit.login('a@b.com', '12345678'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>(),
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
            )).thenAnswer(
          (_) async => UserModel(
            id: '1',
            email: 'a@b.com',
            fullName: 'A',
          ),
        );

        return AuthCubit(
          login: login,
          signup: signup,
        );
      },
      act: (cubit) => cubit.login('a@b.com', '12345678'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>(),
      ],
    );
  });
}
