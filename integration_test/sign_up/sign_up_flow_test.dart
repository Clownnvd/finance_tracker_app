import 'package:dio/dio.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:finance_tracker_app/core/constants/app_config.dart';
import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/repositories/auth_repository.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/login.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/sign_up.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/sign_up_screen.dart';

class _DummyAuthRepository implements AuthRepository {
  @override
  Future<UserModel> login({
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signup({
    required String email,
    required String password,
    required String fullName,
    CancelToken? cancelToken,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout({CancelToken? cancelToken}) async {}
}

class _DummyLogin extends Login {
  _DummyLogin() : super(_DummyAuthRepository());

  @override
  Future<UserModel> call({
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) {
    throw UnimplementedError();
  }
}

class _DummySignup extends Signup {
  _DummySignup() : super(_DummyAuthRepository());

  @override
  Future<UserModel> call({
    required String fullName,
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) {
    throw UnimplementedError();
  }
}

class _SuccessAuthCubit extends AuthCubit {
  _SuccessAuthCubit() : super(login: _DummyLogin(), signup: _DummySignup());

  @override
  Future<void> signup(String fullName, String email, String password) async {
    emit(AuthLoading(attempt: 1, maxAttempts: AppConfig.maxRetryAttempts));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    emit(AuthSuccess(UserModel(id: '1', email: email, fullName: fullName)));
  }

  @override
  Future<void> login(String email, String password) async {}
}

class _ErrorAuthCubit extends AuthCubit {
  final String message;

  _ErrorAuthCubit(this.message)
      : super(login: _DummyLogin(), signup: _DummySignup());

  @override
  Future<void> signup(String fullName, String email, String password) async {
    emit(AuthLoading(attempt: 1, maxAttempts: AppConfig.maxRetryAttempts));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    emit(AuthFailure(message));
  }

  @override
  Future<void> login(String email, String password) async {}
}

class _FakeLoginScreen extends StatelessWidget {
  const _FakeLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      key: Key('login-screen'),
      body: Center(child: Text('Login Screen')),
    );
  }
}

Future<void> _pumpWithCubit(
  WidgetTester tester,
  AuthCubit cubit,
) async {
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: AppRouter.navigatorKey,
      theme: AppTheme.light,
      onGenerateRoute: AppRouter.onGenerateRoute,
      routes: {
        '/': (_) => BlocProvider<AuthCubit>.value(
              value: cubit,
              child: const SignUpScreen(),
            ),
        AppRoutes.login: (_) => const _FakeLoginScreen(),
      },
    ),
  );
  await tester.pumpAndSettle();
}

Finder _fullNameField() =>
    find.widgetWithText(TextFormField, AppStrings.fullNameLabel);
Finder _emailField() =>
    find.widgetWithText(TextFormField, AppStrings.emailLabel);
Finder _passwordField() =>
    find.widgetWithText(TextFormField, AppStrings.passwordLabel);
Finder _confirmPasswordField() =>
    find.widgetWithText(TextFormField, AppStrings.confirmPasswordLabel);
Finder _signUpButton() =>
    find.widgetWithText(ElevatedButton, AppStrings.signUpTitle);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SignUp integration flow', () {
    testWidgets('complete signup flow with valid data', (tester) async {
      final cubit = _SuccessAuthCubit();
      await _pumpWithCubit(tester, cubit);

      await tester.enterText(_fullNameField(), 'Test User');
      await tester.enterText(_emailField(), 'test@example.com');
      await tester.enterText(_passwordField(), 'Password123!');
      await tester.enterText(_confirmPasswordField(), 'Password123!');

      await tester.tap(_signUpButton());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text(AppStrings.signUpSuccess), findsOneWidget);

      await tester.pump(
        const Duration(milliseconds: AppConfig.successSnackDelayMs + 50),
      );

      expect(find.byKey(const Key('login-screen')), findsOneWidget);
    });

    testWidgets('signup flow with invalid email', (tester) async {
      final cubit = _SuccessAuthCubit();
      await _pumpWithCubit(tester, cubit);

      await tester.enterText(_fullNameField(), 'Test User');
      await tester.enterText(_emailField(), 'invalid_email');
      await tester.enterText(_passwordField(), 'Password123!');
      await tester.enterText(_confirmPasswordField(), 'Password123!');

      await tester.tap(_signUpButton());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.invalidEmailFormat), findsOneWidget);
      expect(find.text(AppStrings.signUpSuccess), findsNothing);
    });

    testWidgets('signup flow with weak password', (tester) async {
      final cubit = _SuccessAuthCubit();
      await _pumpWithCubit(tester, cubit);

      await tester.enterText(_fullNameField(), 'Test User');
      await tester.enterText(_emailField(), 'test@example.com');
      await tester.enterText(_passwordField(), '123');
      await tester.enterText(_confirmPasswordField(), '123');

      await tester.tap(_signUpButton());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.passwordMinLength8), findsOneWidget);
      expect(find.text(AppStrings.signUpSuccess), findsNothing);
    });

    testWidgets('signup flow with password mismatch', (tester) async {
      final cubit = _SuccessAuthCubit();
      await _pumpWithCubit(tester, cubit);

      await tester.enterText(_fullNameField(), 'Test User');
      await tester.enterText(_emailField(), 'test@example.com');
      await tester.enterText(_passwordField(), 'Password123!');
      await tester.enterText(_confirmPasswordField(), 'Password321!');

      await tester.tap(_signUpButton());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.passwordNotMatch), findsOneWidget);
    });

    testWidgets('shows error SnackBar on signup failure', (tester) async {
      final cubit = _ErrorAuthCubit('Network error');
      await _pumpWithCubit(tester, cubit);

      await tester.enterText(_fullNameField(), 'Test User');
      await tester.enterText(_emailField(), 'test@example.com');
      await tester.enterText(_passwordField(), 'Password123!');
      await tester.enterText(_confirmPasswordField(), 'Password123!');

      await tester.tap(_signUpButton());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Network error'), findsOneWidget);
      expect(find.byKey(const Key('login-screen')), findsNothing);
    });

    testWidgets('signup flow with existing email error', (tester) async {
      final cubit = _ErrorAuthCubit('Email already exists');
      await _pumpWithCubit(tester, cubit);

      await tester.enterText(_fullNameField(), 'Test User');
      await tester.enterText(_emailField(), 'test@example.com');
      await tester.enterText(_passwordField(), 'Password123!');
      await tester.enterText(_confirmPasswordField(), 'Password123!');

      await tester.tap(_signUpButton());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Email already exists'), findsOneWidget);
      expect(find.byKey(const Key('login-screen')), findsNothing);
    });
  });
}
