import 'package:bloc_test/bloc_test.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/login.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/sign_up.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';

// ✅ sửa đúng path nếu khác
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';

// ===== Mocks =====
class MockLogin extends Mock implements Login {}

class MockSignup extends Mock implements Signup {}

class MockUserModel extends Mock implements UserModel {}

void main() {
  late MockLogin mockLogin;
  late MockSignup mockSignup;
  late AuthCubit cubit;

  const email = 'test@example.com';
  const password = '12345678';

  setUp(() {
    mockLogin = MockLogin();
    mockSignup = MockSignup();
    cubit = AuthCubit(login: mockLogin, signup: mockSignup);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('AuthCubit.login', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthSuccess] when login success',
      build: () {
        final user = MockUserModel();
        when(() => user.email).thenReturn(email);

        when(() => mockLogin.call(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => user);

        return cubit;
      },
      act: (c) => c.login(email, password),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>().having((s) => s.user.email, 'user.email', email),
      ],
      verify: (_) {
        verify(() => mockLogin.call(email: email, password: password)).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthFailure] when login throws AuthException (no retry)',
      build: () {
        when(() => mockLogin.call(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(const AuthException('Invalid credentials'));

        return cubit;
      },
      act: (c) => c.login(email, password),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>()
            .having((s) => s.message, 'message', 'Invalid credentials'),
      ],
      verify: (_) {
        verify(() => mockLogin.call(email: email, password: password)).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'retries 2 times for NetworkException then emits Failure on 2nd failure',
      build: () {
        when(() => mockLogin.call(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async {
          throw const NetworkException('No internet');
        });

        return cubit;
      },
      act: (c) => c.login(email, password),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>().having((s) => s.message, 'message', 'No internet'),
      ],
      verify: (_) {
        // AuthCubit retry maxAttempts = 2
        verify(() => mockLogin.call(email: email, password: password)).called(2);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'retries once for TimeoutRequestException then succeeds on 2nd attempt',
      build: () {
        final user = MockUserModel();
        when(() => user.email).thenReturn(email);

        var attempt = 0;

        when(() => mockLogin.call(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async {
          attempt++;
          if (attempt == 1) {
            throw const TimeoutRequestException('Timeout');
          }
          return user;
        });

        return cubit;
      },
      act: (c) => c.login(email, password),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>().having((s) => s.user.email, 'user.email', email),
      ],
      verify: (_) {
        verify(() => mockLogin.call(email: email, password: password)).called(2);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'if already AuthSuccess then emits AuthFailure("You are already logged in.") and does NOT call Login usecase',
      build: () => cubit,
      seed: () {
        final user = MockUserModel();
        when(() => user.email).thenReturn(email);
        return AuthSuccess(user);
      },
      act: (c) => c.login(email, password),
      expect: () => [
        isA<AuthFailure>().having(
          (s) => s.message,
          'message',
          'You are already logged in.',
        ),
      ],
      verify: (_) {
        verifyNever(() => mockLogin.call(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ));
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthFailure("Unexpected error. Please try again.")] when unknown error occurs',
      build: () {
        when(() => mockLogin.call(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(Exception('boom'));

        return cubit;
      },
      act: (c) => c.login(email, password),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>().having(
          (s) => s.message,
          'message',
          'Unexpected error. Please try again.',
        ),
      ],
      verify: (_) {
        verify(() => mockLogin.call(email: email, password: password)).called(1);
      },
    );
  });
}
