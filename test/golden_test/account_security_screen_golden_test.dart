import 'package:bloc_test/bloc_test.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/settings/presentation/pages/account_security_screen.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

Widget _buildGoldenApp(AuthCubit cubit) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: BlocProvider<AuthCubit>.value(
      value: cubit,
      child: const AccountSecurityScreen(),
    ),
  );
}

Future<void> _pumpStable(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(const AuthInitial());
  });

  group('AccountSecurityScreen golden', () {
    testWidgets('initial state', (tester) async {
      final cubit = MockAuthCubit();

      when(() => cubit.state).thenReturn(const AuthInitial());
      whenListen<AuthState>(
        cubit,
        const Stream<AuthState>.empty(),
        initialState: const AuthInitial(),
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(AccountSecurityScreen),
        matchesGoldenFile('goldens/account_security_screen_initial.png'),
      );
    });

    testWidgets('logout loading state', (tester) async {
      final cubit = MockAuthCubit();

      const loading = AuthLoading(attempt: 1, maxAttempts: 3);

      when(() => cubit.state).thenReturn(loading);
      whenListen<AuthState>(
        cubit,
        Stream<AuthState>.fromIterable([loading]),
        initialState: loading,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(AccountSecurityScreen),
        matchesGoldenFile('goldens/account_security_screen_logout_loading.png'),
      );
    });
  });
}
