import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/pages/sign_up_screen.dart';

class FakeAuthCubit extends Cubit<AuthState> implements AuthCubit {
  FakeAuthCubit(AuthState initialState) : super(initialState);

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> signup(String fullName, String email, String password) async {}

  @override
  void emit(AuthState state) => super.emit(state);
}

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

  group('SignUpScreen golden', () {
    testWidgets('initial state', (tester) async {
      final cubit = FakeAuthCubit(AuthInitial());

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pump();

      await expectLater(
        find.byType(SignUpScreen),
        matchesGoldenFile('goldens/sign_up_screen_initial.png'),
      );
    });

    testWidgets('validation errors', (tester) async {
      final cubit = FakeAuthCubit(AuthInitial());

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pump();

      final buttonFinder =
          find.widgetWithText(ElevatedButton, 'Sign Up');
      await tester.ensureVisible(buttonFinder);
      await tester.tap(buttonFinder);
      await tester.pump();

      await expectLater(
        find.byType(SignUpScreen),
        matchesGoldenFile(
          'goldens/sign_up_screen_validation_errors.png',
        ),
      );
    });

    testWidgets('loading state', (tester) async {
      final cubit = FakeAuthCubit(AuthLoading());

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pump();

      await expectLater(
        find.byType(SignUpScreen),
        matchesGoldenFile('goldens/sign_up_screen_loading.png'),
      );
    });

    testWidgets('error state', (tester) async {
      final cubit = FakeAuthCubit(AuthFailure('Something went wrong'));

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pump();

      await expectLater(
        find.byType(SignUpScreen),
        matchesGoldenFile('goldens/sign_up_screen_error.png'),
      );
    });
  });
}
