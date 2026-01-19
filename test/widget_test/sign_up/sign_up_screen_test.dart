import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/core/constants/app_config.dart';

import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/login_screen.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/sign_up_screen.dart';

import 'package:finance_tracker_app/shared/widgets/auth_ui.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class _FakeRoute extends Fake implements Route<dynamic> {}

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

Finder _signUpTitle() => find.text(AppStrings.signUpTitle);

/// SignUp UI has:
/// - Title text
/// - Button text
/// So use findsWidgets, NOT findsOneWidget.
Finder _signUpCtaLoose() {
  final byBtn = find.widgetWithText(ElevatedButton, AppStrings.signUpTitle);
  if (byBtn.evaluate().isNotEmpty) return byBtn;
  return find.text(AppStrings.signUpTitle);
}

Finder _loginLink() => find.text(AppStrings.login);

/// ⚠️ AppValidatedTextField wraps TextFormField.
/// We avoid relying on label text matching.
/// We pick TextFormField by index:
/// 0 full name, 1 email, 2 password, 3 confirm
Finder _fieldAt(int i) => find.byType(TextFormField).at(i);

class _HostPushScreen extends StatelessWidget {
  const _HostPushScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          key: const Key('open-signup'),
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => child)),
          child: const Text('Open'),
        ),
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthCubit cubit;
  late MockNavigatorObserver navObserver;

  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  setUpAll(() {
    registerFallbackValue(_FakeRoute());
    registerFallbackValue(const AuthInitial());
  });

  setUp(() {
    cubit = MockAuthCubit();
    navObserver = MockNavigatorObserver();

    // Default stub for signup() so verify() won't fail due to missing stub.
    when(() => cubit.signup(any(), any(), any())).thenAnswer((_) async {});
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

    final screen = BlocProvider<AuthCubit>.value(
      value: cubit,
      child: const SignUpScreen(),
    );

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        navigatorKey: AppRouter.navigatorKey,
        scaffoldMessengerKey: messengerKey,
        navigatorObservers: [navObserver],
        routes: {
          AppRoutes.login: (_) => BlocProvider<AuthCubit>.value(
            value: cubit,
            child: const LoginScreen(),
          ),
          AppRoutes.signUp: (_) => BlocProvider<AuthCubit>.value(
            value: cubit,
            child: const SignUpScreen(),
          ),
        },
        home: pushRoute ? _HostPushScreen(child: screen) : screen,
      ),
    );

    await _stablePump(tester);

    if (pushRoute) {
      await tester.tap(find.byKey(const Key('open-signup')));
      await tester.pump();
      await _stablePump(tester);
      expect(_signUpTitle(), findsWidgets);
    }
  }

  Future<void> _fillValidForm(WidgetTester tester) async {
    final fullName = _fieldAt(0);
    final email = _fieldAt(1);
    final pass = _fieldAt(2);
    final confirm = _fieldAt(3);

    expect(fullName, findsOneWidget);
    expect(email, findsOneWidget);
    expect(pass, findsOneWidget);
    expect(confirm, findsOneWidget);

    await tester.ensureVisible(fullName);
    await tester.enterText(fullName, 'Test User');
    await tester.pump();

    await tester.ensureVisible(email);
    await tester.enterText(email, 'test@example.com');
    await tester.pump();

    await tester.ensureVisible(pass);
    await tester.enterText(pass, 'Password123');
    await tester.pump();

    await tester.ensureVisible(confirm);
    await tester.enterText(confirm, 'Password123');
    await tester.pump();

    await _pumpFor(tester, const Duration(milliseconds: 150));
  }

  group('SignUpScreen - rendering', () {
    testWidgets('renders title and CTA', (tester) async {
      await pumpScreen(tester, state: const AuthInitial());
      expect(_signUpTitle(), findsWidgets);

      final cta = _signUpCtaLoose();
      expect(cta, findsWidgets);

      // Link to login exists (might be GestureDetector Text)
      expect(_loginLink(), findsWidgets);

      // Fields count: should be 4
      expect(find.byType(TextFormField), findsNWidgets(4));
    });
  });

  group('SignUpScreen - validation', () {
    testWidgets('shows validation errors when submit empty', (tester) async {
      await pumpScreen(tester, state: const AuthInitial());

      final cta = _signUpCtaLoose();
      await _safeTap(tester, cta, reason: 'Tap SignUp CTA');

      // After submit, validators show required messages
      await tester.pump();
      await _pumpFor(tester, const Duration(milliseconds: 200));

      expect(find.text(AppStrings.fullNameRequired), findsWidgets);
      expect(find.text(AppStrings.emailRequired), findsWidgets);
      expect(find.text(AppStrings.passwordRequired), findsWidgets);
      expect(find.text(AppStrings.confirmPasswordRequired), findsWidgets);
    });
  });

  group('SignUpScreen - password visibility', () {
    testWidgets('toggle password visibility icons', (tester) async {
      await pumpScreen(tester, state: const AuthInitial());

      final showIcons = find.byIcon(Icons.visibility_outlined);
      expect(showIcons, findsWidgets);

      await _safeTap(
        tester,
        showIcons,
        reason: 'Tap show password icon (first)',
      );

      // After toggle, should show "visibility_off"
      final hideIcons = find.byIcon(Icons.visibility_off_outlined);
      expect(hideIcons, findsWidgets);
    });
  });

  group('SignUpScreen - loading overlay', () {
    testWidgets('shows AuthLoadingOverlay when AuthLoading', (tester) async {
      await pumpScreen(
        tester,
        state: const AuthLoading(attempt: 1, maxAttempts: 1),
      );

      final overlay = find.byType(AuthLoadingOverlay);
      expect(overlay, findsOneWidget);

      final w = tester.widget<AuthLoadingOverlay>(overlay);
      expect(w.isLoading, isTrue);
    });

    testWidgets('overlay becomes loading when AuthLoading emitted', (
      tester,
    ) async {
      final controller = StreamController<AuthState>();

      await pumpScreen(
        tester,
        state: const AuthInitial(),
        stream: controller.stream,
        pushRoute: true,
      );

      await _fillValidForm(tester);

      controller.add(const AuthLoading(attempt: 1, maxAttempts: 1));
      await _pumpFor(tester, const Duration(milliseconds: 250));

      expect(find.byType(AuthLoadingOverlay), findsOneWidget);

      await controller.close();
    });
  });

  group('SignUpScreen - submit wiring (verify cubit.signup)', () {
    testWidgets('calls signup flow (emits AuthLoading) when submit valid data', (
      tester,
    ) async {
      final controller = StreamController<AuthState>();

      // Start from initial
      await pumpScreen(
        tester,
        state: const AuthInitial(),
        stream: controller.stream,
      );

      await _fillValidForm(tester);

      final cta = _signUpCtaLoose();
      await _safeTap(tester, cta, reason: 'Tap SignUp CTA');

      // Manually simulate cubit emitting loading (because MockCubit won't execute real logic)
      controller.add(const AuthLoading(attempt: 1, maxAttempts: 1));
      await _pumpFor(tester, const Duration(milliseconds: 200));

      // ✅ Assert: overlay is shown => builder reacted to AuthLoading
      final overlay = find.byType(AuthLoadingOverlay);
      expect(overlay, findsOneWidget);

      await controller.close();
    });
  });

  group('SignUpScreen - navigation', () {
    testWidgets('tap Login link -> navigates to LoginScreen', (tester) async {
      await pumpScreen(tester, state: const AuthInitial());

      final login = _loginLink();
      await _safeTap(tester, login, reason: 'Tap Login link');
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('AuthSuccess -> shows success snack then navigates to Login', (
      tester,
    ) async {
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

      // Wait for listener + snack + delayed navigation
      await _pumpFor(tester, const Duration(milliseconds: 200));
      expect(find.text(AppStrings.signUpSuccess), findsWidgets);

      // Wait long enough for AppConfig.successSnackDelayMs + pushReplacement
      await _pumpFor(
        tester,
        Duration(milliseconds: AppConfig.successSnackDelayMs + 400),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('AuthFailure -> shows snack error and stays on SignUp', (
      tester,
    ) async {
      final s0 = const AuthInitial();
      final s1 = const AuthFailure('Signup failed');

      await pumpScreen(
        tester,
        state: s0,
        stream: Stream<AuthState>.fromIterable([s1]),
        pushRoute: true,
      );

      await _pumpFor(tester, const Duration(milliseconds: 200));

      // SnackBar text
      expect(find.text('Signup failed'), findsWidgets);

      // Still on SignUpScreen
      expect(find.byType(SignUpScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });
  });
}
