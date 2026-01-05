import 'package:dio/dio.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/repositories/auth_repository.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/login.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/sign_up.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/login_screen.dart';
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

class _SuccessLoginCubit extends AuthCubit {
  _SuccessLoginCubit() : super(login: _DummyLogin(), signup: _DummySignup());

  @override
  Future<void> login(String email, String password) async {
    emit(const AuthLoading(attempt: 1, maxAttempts: 3));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    emit(AuthSuccess(UserModel(id: '1', email: email, fullName: 'User')));
  }

  @override
  Future<void> signup(String fullName, String email, String password) async {}
}

class _ErrorLoginCubit extends AuthCubit {
  final String message;

  _ErrorLoginCubit(this.message)
      : super(login: _DummyLogin(), signup: _DummySignup());

  @override
  Future<void> login(String email, String password) async {
    emit(const AuthLoading(attempt: 1, maxAttempts: 3));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    emit(AuthFailure(message));
  }

  @override
  Future<void> signup(String fullName, String email, String password) async {}
}

class _FakeDashboardScreen extends StatelessWidget {
  const _FakeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      key: Key('dashboard-screen'),
      body: Center(child: Text('Dashboard Screen')),
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
        AppRoutes.login: (_) => BlocProvider<AuthCubit>.value(
              value: cubit,
              child: const LoginScreen(),
            ),
        AppRoutes.signUp: (_) => BlocProvider<AuthCubit>.value(
              value: cubit,
              child: const SignUpScreen(),
            ),
        AppRoutes.dashboard: (_) => const _FakeDashboardScreen(),
      },
      initialRoute: AppRoutes.login,
    ),
  );
  await tester.pumpAndSettle();
}

Finder _emailField() =>
    find.widgetWithText(TextFormField, AppStrings.emailLabel);
Finder _passwordField() =>
    find.widgetWithText(TextFormField, AppStrings.passwordLabel);
Finder _loginButton() =>
    find.widgetWithText(ElevatedButton, AppStrings.login);
Finder _registerText() => find.text(AppStrings.register);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login integration flow', () {
    testWidgets('complete login flow with valid data', (tester) async {
      final cubit = _SuccessLoginCubit();
      await _pumpWithCubit(tester, cubit);

      await tester.enterText(_emailField(), 'test@example.com');
      await tester.enterText(_passwordField(), 'Password123!');

      await tester.tap(_loginButton());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('dashboard-screen')), findsOneWidget);
    });

    testWidgets('login flow with invalid email', (tester) async {
      final cubit = _SuccessLoginCubit();
      await _pumpWithCubit(tester, cubit);

      await tester.enterText(_emailField(), 'invalid_email');
      await tester.enterText(_passwordField(), 'Password123!');

      await tester.tap(_loginButton());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.invalidEmailFormat), findsOneWidget);
      expect(find.byKey(const Key('dashboard-screen')), findsNothing);
    });

    testWidgets('login flow with weak password', (tester) async {
      final cubit = _SuccessLoginCubit();
      await _pumpWithCubit(tester, cubit);

      await tester.enterText(_emailField(), 'test@example.com');
      await tester.enterText(_passwordField(), '123');

      await tester.tap(_loginButton());
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.passwordMinLength8), findsOneWidget);
      expect(find.byKey(const Key('dashboard-screen')), findsNothing);
    });

    testWidgets('shows error SnackBar on login failure', (tester) async {
      final cubit = _ErrorLoginCubit('Login failed');
      await _pumpWithCubit(tester, cubit);

      await tester.enterText(_emailField(), 'test@example.com');
      await tester.enterText(_passwordField(), 'Password123!');

      await tester.tap(_loginButton());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Login failed'), findsOneWidget);
      expect(find.byKey(const Key('dashboard-screen')), findsNothing);
    });

    testWidgets('navigates to SignUpScreen when "Register" tapped',
        (tester) async {
      final cubit = _SuccessLoginCubit();
      await _pumpWithCubit(tester, cubit);

      await tester.tap(_registerText());
      await tester.pumpAndSettle();

      expect(find.byType(SignUpScreen), findsOneWidget);
    });
  });
}
