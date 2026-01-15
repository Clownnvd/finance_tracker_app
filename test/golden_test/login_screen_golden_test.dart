import 'package:bloc_test/bloc_test.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/login_screen.dart';
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
      child: const LoginScreen(),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(const AuthInitial());
  });

  group('LoginScreen golden', () {
    testWidgets('initial state', (tester) async {
      final cubit = MockAuthCubit();

      when(() => cubit.state).thenReturn(const AuthInitial());
      whenListen<AuthState>(
        cubit,
        const Stream<AuthState>.empty(),
        initialState: const AuthInitial(),
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_screen_initial.png'),
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
      await tester.pumpAndSettle();

      final buttonFinder = find.widgetWithText(ElevatedButton, AppStrings.login);
      await tester.ensureVisible(buttonFinder);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_screen_validation_errors.png'),
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
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_screen_loading.png'),
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
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(LoginScreen),
        matchesGoldenFile('goldens/login_screen_error.png'),
      );
    });
  });
}
