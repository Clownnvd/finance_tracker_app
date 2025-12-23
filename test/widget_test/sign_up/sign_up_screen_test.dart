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
      },
      home: BlocProvider<AuthCubit>.value(
        value: authCubit,
        child: child,
      ),
    );
  }

  Future<void> fillValidForm(WidgetTester tester) async {
    await tester.enterText(
      find.widgetWithText(TextFormField, AppStrings.fullNameLabel),
      'Test User',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, AppStrings.emailLabel),
      'test@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, AppStrings.passwordLabel),
      'Password123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, AppStrings.confirmPasswordLabel),
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
    await tester.pumpWidget(buildTestApp(const SignUpScreen()));
    await tester.pump();

    expect(find.text(AppStrings.signUpTitle), findsNWidgets(2));
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.text(AppStrings.fullNameLabel), findsNWidgets(1));
    expect(find.text(AppStrings.emailLabel), findsNWidgets(2));
    expect(find.text(AppStrings.passwordLabel), findsNWidgets(2));
    expect(find.text(AppStrings.confirmPasswordLabel), findsNWidgets(1));
    expect(find.text(AppStrings.alreadyHaveAccount), findsOneWidget);
    expect(find.text(AppStrings.login), findsOneWidget);
  });

  testWidgets('shows validation errors when fields are empty', (tester) async {
    await tester.pumpWidget(buildTestApp(const SignUpScreen()));
    await tester.pump();

    final buttonFinder =
        find.widgetWithText(ElevatedButton, AppStrings.signUpTitle);
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();

    expect(find.text(AppStrings.fullNameRequired), findsOneWidget);
    expect(find.text(AppStrings.emailRequired), findsOneWidget);
    expect(find.text(AppStrings.passwordRequired), findsOneWidget);
    expect(find.text(AppStrings.confirmPasswordRequired), findsOneWidget);
  });

  testWidgets('password visibility toggle works', (tester) async {
    await tester.pumpWidget(buildTestApp(const SignUpScreen()));
    await tester.pump();

    final showIcon = find.byIcon(Icons.visibility_outlined).first;
    expect(showIcon, findsOneWidget);

    await tester.ensureVisible(showIcon);
    await tester.tap(showIcon);
    await tester.pump();

    final hideIcon = find.byIcon(Icons.visibility_off_outlined).first;
    expect(hideIcon, findsOneWidget);
  });

  testWidgets('button shows loading overlay when signing up', (tester) async {
    final completer = Completer<UserModel>();

    when(
      () => mockSignup(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer((_) => completer.future);

    await tester.pumpWidget(buildTestApp(const SignUpScreen()));
    await tester.pump();
    await fillValidForm(tester);

    final buttonFinder =
        find.widgetWithText(ElevatedButton, AppStrings.signUpTitle);
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

  testWidgets('calls Signup usecase when button pressed with valid data',
      (tester) async {
    when(
      () => mockSignup(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer(
      (_) async => const UserModel(
        id: '1',
        email: 'test@example.com',
        fullName: 'Test User',
      ),
    );

    await tester.pumpWidget(buildTestApp(const SignUpScreen()));
    await tester.pump();
    await fillValidForm(tester);

    final buttonFinder =
        find.widgetWithText(ElevatedButton, AppStrings.signUpTitle);
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();

    verify(
      () => mockSignup(
        email: 'test@example.com',
        password: 'Password123',
        fullName: 'Test User',
      ),
    ).called(1);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();
  });

  testWidgets('navigates to LoginScreen when "Login" tapped', (tester) async {
    await tester.pumpWidget(buildTestApp(const SignUpScreen()));
    await tester.pump();

    final loginText = find.text(AppStrings.login);
    await tester.ensureVisible(loginText);
    await tester.tap(loginText);
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('navigates to LoginScreen after successful signup',
      (tester) async {
    when(
      () => mockSignup(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer(
      (_) async => const UserModel(
        id: '1',
        email: 'test@example.com',
        fullName: 'User',
      ),
    );

    await tester.pumpWidget(buildTestApp(const SignUpScreen()));
    await tester.pump();
    await fillValidForm(tester);

    final buttonFinder =
        find.widgetWithText(ElevatedButton, AppStrings.signUpTitle);
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('shows error SnackBar on signup failure', (tester) async {
    when(
      () => mockSignup(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenThrow(const AuthException('Signup failed'));

    await tester.pumpWidget(buildTestApp(const SignUpScreen()));
    await tester.pump();
    await fillValidForm(tester);

    final buttonFinder =
        find.widgetWithText(ElevatedButton, AppStrings.signUpTitle);
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Signup failed'), findsOneWidget);
  });
}
