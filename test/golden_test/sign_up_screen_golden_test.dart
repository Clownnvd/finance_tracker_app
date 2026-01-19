import 'package:bloc_test/bloc_test.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

Widget _buildGoldenApp(AuthCubit cubit) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: BlocProvider<AuthCubit>.value(
      value: cubit,
      child: const SignUpScreen(),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Fallback for mocktail when the framework needs a default AuthState instance.
    registerFallbackValue(const AuthInitial());
  });

  // ---- Helpers ----

  /// Prefer pumping a controlled duration instead of pumpAndSettle()
  /// to avoid timeouts caused by infinite animations/loading overlays.
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

  /// Finds the primary CTA by its text only (UI may not use ElevatedButton).
  Finder _signUpCta() => find.text(AppStrings.signUpTitle).hitTestable();

  group('SignUpScreen golden (UI-safe)', () {
    testWidgets('initial state', (tester) async {
      final cubit = MockAuthCubit();

      when(() => cubit.state).thenReturn(const AuthInitial());
      whenListen<AuthState>(
        cubit,
        const Stream<AuthState>.empty(),
        initialState: const AuthInitial(),
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pump(); // first frame
      await pumpFor(tester, const Duration(milliseconds: 300));

      await expectLater(
        find.byType(SignUpScreen),
        matchesGoldenFile('goldens/sign_up_screen_initial.png'),
      );
    });

    testWidgets('validation errors', (tester) async {
      final cubit = MockAuthCubit();

      when(() => cubit.state).thenReturn(const AuthInitial());
      whenListen<AuthState>(
        cubit,
        const Stream<AuthState>.empty(),
        initialState: const AuthInitial(),
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pump();
      await pumpFor(tester, const Duration(milliseconds: 300));

      // Tap the CTA without relying on ElevatedButton.
      final cta = _signUpCta();
      expect(cta, findsWidgets, reason: 'SignUp CTA text should exist on screen.');

      await tester.ensureVisible(cta.first);
      await tester.tap(cta.first);

      // Let validators + error text render.
      await tester.pump();
      await pumpFor(tester, const Duration(milliseconds: 500));

      await expectLater(
        find.byType(SignUpScreen),
        matchesGoldenFile('goldens/sign_up_screen_validation_errors.png'),
      );
    });

    testWidgets('loading state', (tester) async {
      final cubit = MockAuthCubit();

      const loading = AuthLoading(attempt: 1, maxAttempts: 3);

      when(() => cubit.state).thenReturn(loading);
      whenListen<AuthState>(
        cubit,
        Stream<AuthState>.fromIterable([loading]),
        initialState: loading,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));

      // Do NOT pumpAndSettle() here (may hang due to animations).
      await tester.pump(); // first frame
      await pumpFor(tester, const Duration(milliseconds: 600));

      await expectLater(
        find.byType(SignUpScreen),
        matchesGoldenFile('goldens/sign_up_screen_loading.png'),
      );
    });

    testWidgets('error state', (tester) async {
      final cubit = MockAuthCubit();

      const failure = AuthFailure(AppStrings.genericError);

      when(() => cubit.state).thenReturn(failure);
      whenListen<AuthState>(
        cubit,
        Stream<AuthState>.fromIterable([failure]),
        initialState: failure,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pump();
      await pumpFor(tester, const Duration(milliseconds: 600));

      await expectLater(
        find.byType(SignUpScreen),
        matchesGoldenFile('goldens/sign_up_screen_error.png'),
      );
    });
  });
}
