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

void main() {
  late MockLogin mockLogin;
  late MockSignup mockSignup;
  late AuthCubit cubit;

  const email = 'test@example.com';
  const password = 'Password123';
  const fullName = 'Test User';

  final user = UserModel(
    id: 'user-1',
    email: email,
    fullName: fullName,
  );

  setUp(() {
    mockLogin = MockLogin();
    mockSignup = MockSignup();
    cubit = AuthCubit(login: mockLogin, signup: mockSignup);
  });

  tearDown(() {
    cubit.close();
  });

  test('signup success emits [AuthLoading, AuthSuccess]', () async {
    when(
      () => mockSignup(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer((_) async => user);

    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<AuthLoading>(),
        AuthSuccess(user),
      ]),
    );

    await cubit.signup(fullName, email, password);
  });

  test('signup failure emits [AuthLoading, AuthFailure]', () async {
    const msg = 'Email already used';

    when(
      () => mockSignup(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenThrow(const AuthException(msg));

    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<AuthLoading>(),
        isA<AuthFailure>().having((s) => s.message, 'message', msg),
      ]),
    );

    await cubit.signup(fullName, email, password);
  });
}
