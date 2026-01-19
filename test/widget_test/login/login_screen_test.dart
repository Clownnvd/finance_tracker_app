import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/dashboard/presentation/pages/dashboard_screen.dart';

import 'package:finance_tracker_app/feature/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:finance_tracker_app/feature/dashboard/presentation/cubit/dashboard_state.dart';

import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/login.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/usecases/sign_up.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/login_screen.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/sign_up_screen.dart';
import 'package:finance_tracker_app/shared/widgets/auth_ui.dart';

class MockLogin extends Mock implements Login {}

class MockSignup extends Mock implements Signup {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class MockDashboardCubit extends MockCubit<DashboardState>
    implements DashboardCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class _FakeRoute extends Fake implements Route<dynamic> {}

class _FakeCancelToken extends Fake implements CancelToken {}

Future<void> _stablePump(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 100));
}

Future<void> _pumpFor(
  WidgetTester tester,
  Duration duration, {
  Duration step = const Duration(milliseconds: 100),
}) async {
  var elapsed = Duration.zero;
  while (elapsed < duration) {
    await tester.pump(step);
    elapsed += step;
  }
}

Future<void> _safeTap(
  WidgetTester tester,
  Finder finder, {
  required String reason,
}) async {
  if (finder.evaluate().isEmpty) {
    fail('Cannot tap ($reason). Finder not found: $finder');
  }
  await tester.ensureVisible(finder.first);
  await tester.tap(finder.first);
  await tester.pump();
}

Finder _loginTitleFinder() => find.text(AppStrings.welcomeTitle);

/// ✅ FIX: avoid hitTestable() here. We'll ensureVisible + tap ourselves.
/// Also add fallback in case button type changes.
Finder _loginCtaFinderLoose() {
  final byBtnText = find.widgetWithText(ElevatedButton, AppStrings.login);
  if (byBtnText.evaluate().isNotEmpty) return byBtnText;
  return find.text(AppStrings.login);
}

Finder _registerFinder() => find.text(AppStrings.register);

Finder _emailField() => find.byType(TextFormField).at(0);

Finder _passwordField() => find.byType(TextFormField).at(1);

class _HostPushScreen extends StatelessWidget {
  const _HostPushScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          key: const Key('open-login'),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => child),
          ),
          child: const Text('Open'),
        ),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLogin mockLogin;
  late MockSignup mockSignup;

  late MockAuthCubit cubit;
  late MockDashboardCubit dashboardCubit;
  late MockNavigatorObserver navObserver;

  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  setUpAll(() {
    registerFallbackValue(_FakeRoute());
    registerFallbackValue(const AuthInitial());
    registerFallbackValue(_FakeCancelToken());
    registerFallbackValue(DashboardState.initial());
  });

  setUp(() {
    mockLogin = MockLogin();
    mockSignup = MockSignup();

    cubit = MockAuthCubit();
    dashboardCubit = MockDashboardCubit();
    navObserver = MockNavigatorObserver();
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    required AuthState state,
    Stream<AuthState>? stream,
    bool pushRoute = false,
  }) async {
    when(() => cubit.state).thenReturn(state);
    whenListen<AuthState>(
      cubit,
      stream ?? const Stream<AuthState>.empty(),
      initialState: state,
    );

    // Dashboard cubit stubs
    when(() => dashboardCubit.state).thenReturn(DashboardState.initial());
    whenListen<DashboardState>(
      dashboardCubit,
      const Stream<DashboardState>.empty(),
      initialState: DashboardState.initial(),
    );
    when(() => dashboardCubit.load()).thenAnswer((_) async {});

    final screen = BlocProvider<AuthCubit>.value(
      value: cubit,
      child: const LoginScreen(),
    );

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        navigatorKey: AppRouter.navigatorKey,
        scaffoldMessengerKey: messengerKey,
        navigatorObservers: [navObserver],
        routes: {
          AppRoutes.signUp: (_) => BlocProvider<AuthCubit>.value(
                value: cubit,
                child: const SignUpScreen(),
              ),
          AppRoutes.dashboard: (_) => BlocProvider<DashboardCubit>.value(
                value: dashboardCubit,
                child: const DashboardScreen(),
              ),
        },
        home: pushRoute ? _HostPushScreen(child: screen) : screen,
      ),
    );

    await _stablePump(tester);

    if (pushRoute) {
      await tester.tap(find.byKey(const Key('open-login')));
      await tester.pump();
      await _stablePump(tester);
      expect(_loginTitleFinder(), findsOneWidget);
    }
  }

  Future<void> _fillValidLoginForm(WidgetTester tester) async {
    final email = _emailField();
    final pass = _passwordField();

    expect(email, findsOneWidget);
    expect(pass, findsOneWidget);

    await tester.ensureVisible(email);
    await tester.enterText(email, 'test@example.com');
    await tester.pump();

    await tester.ensureVisible(pass);
    await tester.enterText(pass, 'Password123');
    await tester.pump();

    await _pumpFor(tester, const Duration(milliseconds: 150));
  }

  group('LoginScreen (NEW UI) - rendering', () {
    testWidgets('renders title and login CTA', (tester) async {
      await pumpScreen(tester, state: const AuthInitial());
      expect(_loginTitleFinder(), findsOneWidget);

      final cta = _loginCtaFinderLoose();
      expect(cta, findsWidgets);

      expect(_registerFinder(), findsWidgets);
    });
  });

  group('LoginScreen (NEW UI) - loading overlay', () {
    testWidgets('shows AuthLoadingOverlay when loading', (tester) async {
      final s = const AuthLoading(attempt: 1, maxAttempts: 1);
      await pumpScreen(tester, state: s);

      final overlay = find.byType(AuthLoadingOverlay);
      expect(overlay, findsOneWidget);

      final w = tester.widget<AuthLoadingOverlay>(overlay);
      expect(w.isLoading, isTrue);
    });
  });

  group('LoginScreen (NEW UI) - failure flow', () {
    testWidgets('AuthFailure -> stays on LoginScreen and shows error text',
        (tester) async {
      final s0 = const AuthInitial();
      final s1 = const AuthFailure('Login failed');

      await pumpScreen(
        tester,
        state: s0,
        stream: Stream<AuthState>.fromIterable([s1]),
        pushRoute: true,
      );

      await _pumpFor(tester, const Duration(milliseconds: 900));
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(DashboardScreen), findsNothing);
      expect(find.text('Login failed'), findsWidgets);
    });
  });

  group('LoginScreen (NEW UI) - submit flow', () {
    testWidgets(
      'when loading -> tapping login should NOT pop route',
      (tester) async {
        await pumpScreen(
          tester,
          state: const AuthLoading(attempt: 1, maxAttempts: 1),
          pushRoute: true,
        );

        final cta = _loginCtaFinderLoose();
        if (cta.evaluate().isNotEmpty) {
          await _safeTap(
            tester,
            cta,
            reason: 'Tap Login CTA while loading',
          );
          await _pumpFor(tester, const Duration(milliseconds: 200));
        }

        verifyNever(() => navObserver.didPop(any(), any()));
      },
    );

    testWidgets(
  'overlay becomes loading when AuthLoading is emitted (no CTA text dependency)',
  (tester) async {
    final s0 = const AuthInitial();

    final controller = StreamController<AuthState>();

    await pumpScreen(
      tester,
      state: s0,
      stream: controller.stream,
      pushRoute: true,
    );

    // Optional: fill form (not required for this test, but safe to keep)
    await _fillValidLoginForm(tester);

    // Emit loading AFTER the screen is rendered.
    controller.add(const AuthLoading(attempt: 1, maxAttempts: 1));

    await _pumpFor(tester, const Duration(milliseconds: 300));

    final overlay = find.byType(AuthLoadingOverlay);
    expect(overlay, findsOneWidget);

    final w = tester.widget<AuthLoadingOverlay>(overlay);
    expect(w.isLoading, isTrue);

    await controller.close();
  },
);



    testWidgets(
      'AuthSuccess -> navigates to DashboardScreen',
      (tester) async {
        final s0 = const AuthInitial();
        final s1 = const AuthSuccess(
          UserModel(id: '1', email: 'test@example.com', fullName: 'User'),
        );

        await pumpScreen(
          tester,
          state: s0,
          stream: Stream<AuthState>.fromIterable([s1]),
          pushRoute: true,
        );

        await _pumpFor(tester, const Duration(milliseconds: 900));
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        expect(find.byType(DashboardScreen), findsOneWidget);
      },
    );

    testWidgets(
      'tap Register -> navigates to SignUpScreen',
      (tester) async {
        await pumpScreen(
          tester,
          state: const AuthInitial(),
          pushRoute: true,
        );

        final reg = _registerFinder();
        expect(reg, findsWidgets);

        await _safeTap(tester, reg, reason: 'Tap Register');
        await tester.pumpAndSettle();

        expect(find.byType(SignUpScreen), findsOneWidget);
      },
    );
  });

  group('AuthCubit (unit-ish) - login usecase wiring', () {
    test('AuthCubit.login calls Login usecase with cancelToken', () async {
      final real = AuthCubit(login: mockLogin, signup: mockSignup);

      when(
        () => mockLogin(
          email: any(named: 'email'),
          password: any(named: 'password'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer(
        (_) async => const UserModel(
          id: '1',
          email: 'test@example.com',
          fullName: 'User',
        ),
      );

      await real.login('test@example.com', 'Password123');

      verify(
        () => mockLogin(
          email: 'test@example.com',
          password: 'Password123',
          cancelToken: any(named: 'cancelToken'),
        ),
      ).called(1);

      await real.close();
    });

    blocTest<AuthCubit, AuthState>(
      'AuthCubit.login emits AuthFailure on AuthException',
      build: () {
        when(
          () => mockLogin(
            email: any(named: 'email'),
            password: any(named: 'password'),
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenThrow(const AuthException('Login failed'));

        return AuthCubit(login: mockLogin, signup: mockSignup);
      },
      act: (c) async {
        await c.login('test@example.com', 'Password123');
      },
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthFailure>().having((s) => s.message, 'message', 'Login failed'),
      ],
    );
  });
}
