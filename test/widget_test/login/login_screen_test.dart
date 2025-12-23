import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/login.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/sign_up.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/dashboard_screen.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/login_screen.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/sign_up_screen.dart';

class MockLogin extends Mock implements Login {}

class MockSignup extends Mock implements Signup {}

void main() {
  late MockLogin mockLogin;
  late MockSignup mockSignup;
  late AuthCubit authCubit;

  Widget buildTestApp(Widget child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: AppRouter.navigatorKey,
      theme: AppTheme.light,
      routes: {
        AppRoutes.login: (_) => BlocProvider<AuthCubit>.value(
              value: authCubit,
              child: const LoginScreen(),
            ),
        AppRoutes.signUp: (_) => BlocProvider<AuthCubit>.value(
              value: authCubit,
              child: const SignUpScreen(),
            ),
        AppRoutes.dashboard: (_) => const DashboardScreen(),
      },
      home: BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: child,
      ),
    );
  }

  Future<void> fillValidLoginForm(WidgetTester tester) async {
    await tester.enterText(
      find.widgetWithText(TextFormField, AppStrings.emailLabel),
      'test@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, AppStrings.passwordLabel),
      'Password123',
    );
  }

  setUp(() {
    mockLogin = MockLogin();
    mockSignup = MockSignup();
    authCubit = AuthCubit(login: mockLogin, signup: mockSignup);
  });

  tearDown(() async {
    await authCubit.close();
  });

  testWidgets('renders all required widgets', (tester) async {
    await tester.pumpWidget(buildTestApp(const LoginScreen()));
    await tester.pump();

    expect(find.text(AppStrings.welcomeTitle), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text(AppStrings.emailLabel), findsOneWidget);
    expect(find.text(AppStrings.passwordLabel), findsOneWidget);
    expect(
      find.widgetWithText(ElevatedButton, AppStrings.login),
      findsOneWidget,
    );
    expect(find.text(AppStrings.dontHaveAccount), findsOneWidget);
    expect(find.text(AppStrings.register), findsOneWidget);
  });

  testWidgets('shows validation errors when fields are empty', (tester) async {
    await tester.pumpWidget(buildTestApp(const LoginScreen()));
    await tester.pump();

    final buttonFinder =
        find.widgetWithText(ElevatedButton, AppStrings.login);
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();

    expect(find.text(AppStrings.emailRequired), findsOneWidget);
    expect(find.text(AppStrings.passwordRequired), findsOneWidget);
  });

  testWidgets('password visibility toggle works', (tester) async {
    await tester.pumpWidget(buildTestApp(const LoginScreen()));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('button shows loading overlay when logging in', (tester) async {
    final completer = Completer<UserModel>();

    when(
      () => mockLogin(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) => completer.future);

    await tester.pumpWidget(buildTestApp(const LoginScreen()));
    await tester.pump();
    await fillValidLoginForm(tester);

    final buttonFinder =
        find.widgetWithText(ElevatedButton, AppStrings.login);
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);

    completer.complete(
      const UserModel(id: '1', email: 'test@example.com', fullName: 'User'),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();
  });

  testWidgets('calls Login usecase when button pressed with valid data',
      (tester) async {
    when(
      () => mockLogin(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer(
      (_) async => const UserModel(
        id: '1',
        email: 'test@example.com',
        fullName: 'User',
      ),
    );

    await tester.pumpWidget(buildTestApp(const LoginScreen()));
    await tester.pump();
    await fillValidLoginForm(tester);

    final buttonFinder =
        find.widgetWithText(ElevatedButton, AppStrings.login);
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();

    verify(
      () => mockLogin(
        email: 'test@example.com',
        password: 'Password123',
      ),
    ).called(1);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();
  });

  testWidgets('navigates to SignUpScreen when "Register" tapped',
      (tester) async {
    await tester.pumpWidget(buildTestApp(const LoginScreen()));
    await tester.pump();

    final registerText = find.text(AppStrings.register);
    await tester.ensureVisible(registerText);
    await tester.tap(registerText);
    await tester.pumpAndSettle();

    expect(find.byType(SignUpScreen), findsOneWidget);
  });

  testWidgets('navigates to DashboardScreen after successful login',
      (tester) async {
    when(
      () => mockLogin(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer(
      (_) async => const UserModel(
        id: '1',
        email: 'test@example.com',
        fullName: 'User',
      ),
    );

    await tester.pumpWidget(buildTestApp(const LoginScreen()));
    await tester.pump();
    await fillValidLoginForm(tester);

    final buttonFinder =
        find.widgetWithText(ElevatedButton, AppStrings.login);
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);
  });

  testWidgets('shows error SnackBar on login failure', (tester) async {
    when(
      () => mockLogin(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(const AuthException('Login failed'));

    await tester.pumpWidget(buildTestApp(const LoginScreen()));
    await tester.pump();
    await fillValidLoginForm(tester);

    final buttonFinder =
        find.widgetWithText(ElevatedButton, AppStrings.login);
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Login failed'), findsOneWidget);
  });
}
