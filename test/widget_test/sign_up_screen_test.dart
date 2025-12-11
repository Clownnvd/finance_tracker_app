import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/login.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/sign_up.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';
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
        find.byType(TextFormField).at(0), 'Test User');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'test@example.com');
    await tester.enterText(
        find.byType(TextFormField).at(2), 'Password123');
    await tester.enterText(
        find.byType(TextFormField).at(3), 'Password123');
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

    expect(find.text('Sign Up'), findsNWidgets(2));
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.text('Full Name'), findsNWidgets(2));
    expect(find.text('Email'), findsNWidgets(2));
    expect(find.text('Password'), findsNWidgets(2));
    expect(find.text('Confirm password'), findsNWidgets(2));
    expect(find.text('Already have an account?'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('shows validation errors when fields are empty', (tester) async {
    await tester.pumpWidget(buildTestApp(const SignUpScreen()));

    final buttonFinder =
        find.widgetWithText(ElevatedButton, 'Sign Up');
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();

    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
  });

  testWidgets('password visibility toggle works', (tester) async {
    await tester.pumpWidget(buildTestApp(const SignUpScreen()));

    final showIcon = find.byIcon(Icons.visibility_outlined).first;
    expect(showIcon, findsOneWidget);

    await tester.ensureVisible(showIcon);
    await tester.tap(showIcon);
    await tester.pump();

    final hideIcon =
        find.byIcon(Icons.visibility_off_outlined).first;
    expect(hideIcon, findsOneWidget);
  });

  testWidgets('button shows loading overlay when signing up',
      (tester) async {
    final completer = Completer<UserModel>();

    when(
      () => mockSignup(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer((_) => completer.future);

    await tester.pumpWidget(buildTestApp(const SignUpScreen()));
    await fillValidForm(tester);

    final buttonFinder =
        find.widgetWithText(ElevatedButton, 'Sign Up');
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);

    completer.complete(
      UserModel(id: '1', email: 'test@example.com', fullName: 'User'),
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
      (_) async => UserModel(
        id: '1',
        email: 'test@example.com',
        fullName: 'Test User',
      ),
    );

    await tester.pumpWidget(buildTestApp(const SignUpScreen()));
    await fillValidForm(tester);

    final buttonFinder =
        find.widgetWithText(ElevatedButton, 'Sign Up');
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

  testWidgets('navigates to LoginScreen when "Login" tapped',
      (tester) async {
    await tester.pumpWidget(buildTestApp(const SignUpScreen()));

    final loginText = find.text('Login');
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
      (_) async => UserModel(
        id: '1',
        email: 'test@example.com',
        fullName: 'User',
      ),
    );

    await tester.pumpWidget(buildTestApp(const SignUpScreen()));
    await fillValidForm(tester);

    final buttonFinder =
        find.widgetWithText(ElevatedButton, 'Sign Up');
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
    await fillValidForm(tester);

    final buttonFinder =
        find.widgetWithText(ElevatedButton, 'Sign Up');
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Signup failed'), findsOneWidget);
  });
}
