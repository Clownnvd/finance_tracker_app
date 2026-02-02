import 'dart:async';

import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/login_screen.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/login.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/logout.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/sign_up.dart';
import 'package:finance_tracker_app/feature/dashboard/presentation/pages/dashboard_screen.dart';

class MockLogin extends Mock implements Login {}

class MockSignup extends Mock implements Signup {}

class MockLogout extends Mock implements Logout {}

class _FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLogin mockLogin;
  late MockSignup mockSignup;
  late MockLogout mockLogout;
  late AuthCubit authCubit;

  setUpAll(() {
    registerFallbackValue(_FakeRoute());
  });

  setUp(() {
    mockLogin = MockLogin();
    mockSignup = MockSignup();
    mockLogout = MockLogout();
    authCubit = AuthCubit(login: mockLogin, signup: mockSignup, logout: mockLogout);
  });

  tearDown(() async {
    await authCubit.close();
  });

  // Pumps a few frames without pumpAndSettle to avoid timeouts from animations.
  Future<void> stablePump(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 50));
  }

  Future<void> pumpFor(
    WidgetTester tester,
    Duration duration, {
    Duration step = const Duration(milliseconds: 50),
  }) async {
    var elapsed = Duration.zero;
    while (elapsed < duration) {
      await tester.pump(step);
      elapsed += step;
    }
  }

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

  Finder emailField() => find.byType(TextFormField).at(0);
  Finder passwordField() => find.byType(TextFormField).at(1);
  Finder loginButton() =>
      find.widgetWithText(ElevatedButton, AppStrings.login).hitTestable();

  Future<void> fillValidLoginForm(WidgetTester tester) async {
    await tester.enterText(emailField(), 'test@example.com');
    // Password must have uppercase, lowercase, number, and special char
    await tester.enterText(passwordField(), 'Password123!');
    await tester.pump();
  }

  group('LoginScreen (NEW UI) widget test', () {
    testWidgets('renders required widgets', (tester) async {
      await tester.pumpWidget(buildTestApp(const LoginScreen()));
      await stablePump(tester);

      expect(find.text(AppStrings.welcomeTitle), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));

      // Labels can appear more than once in custom widgets; don't require exactly one.
      expect(find.text(AppStrings.emailLabel), findsWidgets);
      expect(find.text(AppStrings.passwordLabel), findsWidgets);

      expect(loginButton(), findsOneWidget);
      expect(find.text(AppStrings.dontHaveAccount), findsOneWidget);
      expect(find.text(AppStrings.register), findsOneWidget);
    });

    testWidgets('shows validation errors when fields are empty', (tester) async {
      await tester.pumpWidget(buildTestApp(const LoginScreen()));
      await stablePump(tester);

      await tester.tap(loginButton());
      await tester.pump();

      // Your validators likely return these AppStrings.
      // If your validators use different strings, update the expectations.
      expect(find.text(AppStrings.emailRequired), findsOneWidget);
      expect(find.text(AppStrings.passwordRequired), findsOneWidget);
    });

    testWidgets('password visibility toggle works', (tester) async {
      await tester.pumpWidget(buildTestApp(const LoginScreen()));
      await stablePump(tester);

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    // Note: Loading overlay, navigation, and SnackBar tests are thoroughly
    // covered in login_screen_test.dart using MockAuthCubit with controlled
    // stream emissions. Those tests are more reliable than using real AuthCubit
    // with mock usecases due to AuthActionRunner's async complexity.

    testWidgets('calls Login usecase when button pressed with valid data',
        (tester) async {
      // Use Completer to keep login in progress and avoid triggering navigation
      final completer = Completer<UserModel>();
      when(
        () => mockLogin(
          email: any(named: 'email'),
          password: any(named: 'password'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildTestApp(const LoginScreen()));
      await stablePump(tester);

      await fillValidLoginForm(tester);

      await tester.tap(loginButton());
      // Give time for async cubit.login() to call the usecase
      await pumpFor(tester, const Duration(milliseconds: 200));

      verify(
        () => mockLogin(
          email: 'test@example.com',
          password: 'Password123!',
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);

      // Complete to avoid pending timer warnings
      completer.complete(
        const UserModel(id: '1', email: 'test@example.com', fullName: 'User'),
      );
    });

    testWidgets('navigates to SignUpScreen when "Register" tapped',
        (tester) async {
      await tester.pumpWidget(buildTestApp(const LoginScreen()));
      await stablePump(tester);

      await tester.tap(find.text(AppStrings.register));
      await tester.pumpAndSettle();

      expect(find.byType(SignUpScreen), findsOneWidget);
    });

    testWidgets('does not call verify(0) patterns; uses verifyNever for no calls',
        (tester) async {
      // Example sanity: if form invalid, login usecase must not be called.
      await tester.pumpWidget(buildTestApp(const LoginScreen()));
      await stablePump(tester);

      await tester.tap(loginButton());
      await tester.pump();

      verifyNever(() => mockLogin(
            email: any(named: 'email'),
            password: any(named: 'password'),
            cancelToken: any(named: 'cancelToken'),
          ));
    });
  });
}
