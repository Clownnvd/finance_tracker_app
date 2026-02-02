import 'package:bloc_test/bloc_test.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/budgets/domain/entities/budget.dart';
import 'package:finance_tracker_app/feature/budgets/presentation/cubit/budgets_cubit.dart';
import 'package:finance_tracker_app/feature/budgets/presentation/cubit/budgets_state.dart';
import 'package:finance_tracker_app/feature/budgets/presentation/pages/set_budget_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBudgetsCubit extends MockCubit<BudgetsState>
    implements BudgetsCubit {}

Widget _buildGoldenApp(BudgetsCubit cubit) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: BlocProvider<BudgetsCubit>.value(
      value: cubit,
      child: const SetBudgetScreen(),
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
    registerFallbackValue(BudgetsState.initial());
    registerFallbackValue(
      const Budget(
        id: 0,
        userId: 'u1',
        categoryId: 1,
        amount: 100,
        month: 1,
      ),
    );
  });

  void stubCubitMethods(MockBudgetsCubit cubit) {
    when(() => cubit.createOrUpdate(
          categoryId: any(named: 'categoryId'),
          amount: any(named: 'amount'),
          month: any(named: 'month'),
        )).thenAnswer((_) async {});
    when(() => cubit.clearLastSaved()).thenReturn(null);
  }

  group('SetBudgetScreen golden', () {
    testWidgets('initial state', (tester) async {
      final cubit = MockBudgetsCubit();
      stubCubitMethods(cubit);

      final state = BudgetsState.initial().copyWith(isLoading: false);

      when(() => cubit.state).thenReturn(state);
      whenListen<BudgetsState>(
        cubit,
        const Stream<BudgetsState>.empty(),
        initialState: state,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(SetBudgetScreen),
        matchesGoldenFile('goldens/set_budget_screen_initial.png'),
      );
    });

    testWidgets('saving state', (tester) async {
      final cubit = MockBudgetsCubit();
      stubCubitMethods(cubit);

      final state = BudgetsState.initial().copyWith(
        isLoading: false,
        isSaving: true,
      );

      when(() => cubit.state).thenReturn(state);
      whenListen<BudgetsState>(
        cubit,
        Stream<BudgetsState>.fromIterable([state]),
        initialState: state,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(SetBudgetScreen),
        matchesGoldenFile('goldens/set_budget_screen_saving.png'),
      );
    });

    testWidgets('error state (SnackBar visible)', (tester) async {
      final cubit = MockBudgetsCubit();
      stubCubitMethods(cubit);

      final s0 = BudgetsState.initial().copyWith(isLoading: false);
      final s1 = s0.copyWith(errorMessage: 'Failed to save budget');

      when(() => cubit.state).thenReturn(s1);
      whenListen<BudgetsState>(
        cubit,
        Stream<BudgetsState>.fromIterable([s1]),
        initialState: s0,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      await expectLater(
        find.byType(SetBudgetScreen),
        matchesGoldenFile('goldens/set_budget_screen_error.png'),
      );
    });
  });
}
