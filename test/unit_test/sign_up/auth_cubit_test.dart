import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/login.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/logout.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/sign_up.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';

class MockLogin extends Mock implements Login {}

class MockSignup extends Mock implements Signup {}

class MockLogout extends Mock implements Logout {}

class _FakeCancelToken extends Fake implements CancelToken {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLogin mockLogin;
  late MockSignup mockSignup;

  const email = 'test@example.com';
  const password = 'Password123';
  const fullName = 'Test User';

  const user = UserModel(
    id: 'user-1',
    email: email,
    fullName: fullName,
  );

  setUpAll(() {
    registerFallbackValue(_FakeCancelToken());
  });

  setUp(() {
    mockLogin = MockLogin();
    mockSignup = MockSignup();
  });

  group('AuthCubit - signup', () {
    blocTest<AuthCubit, AuthState>(
      'success emits [AuthLoading, AuthSuccess]',
      build: () {
        final mockLogout = MockLogout();
        when(() => mockSignup(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => user);

        return AuthCubit(login: mockLogin, signup: mockSignup, logout: mockLogout);
      },
      act: (c) => c.signup(fullName, email, password),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>().having((s) => s.user, 'user', user),
      ],
      verify: (_) {
        verify(() => mockSignup(
              email: email,
              password: password,
              fullName: fullName,
              cancelToken: any(named: 'cancelToken'),
            )).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'failure emits [AuthLoading, AuthFailure]',
      build: () {
        final mockLogout = MockLogout();
        const msg = 'Email already used';

        when(() => mockSignup(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
              cancelToken: any(named: 'cancelToken'),
            )).thenThrow(const AuthException(msg));

        return AuthCubit(login: mockLogin, signup: mockSignup, logout: mockLogout);
      },
      act: (c) => c.signup(fullName, email, password),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>()
            .having((s) => s.message, 'message', 'Email already used'),
      ],
      verify: (_) {
        verify(() => mockSignup(
              email: email,
              password: password,
              fullName: fullName,
              cancelToken: any(named: 'cancelToken'),
            )).called(1);
      },
    );
  });
}
