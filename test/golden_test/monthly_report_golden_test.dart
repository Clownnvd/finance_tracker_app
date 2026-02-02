import 'package:bloc_test/bloc_test.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/category_total.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/monthly_summary.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/monthly_trend.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/top_expense.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/money.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/report_month.dart';
import 'package:finance_tracker_app/feature/monthly_report/presentation/cubit/monthly_report_cubit.dart';
import 'package:finance_tracker_app/feature/monthly_report/presentation/cubit/monthly_report_state.dart';
import 'package:finance_tracker_app/feature/monthly_report/presentation/widgets/monthly_report_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMonthlyReportCubit extends MockCubit<MonthlyReportState>
    implements MonthlyReportCubit {}

Widget _buildGoldenApp(MonthlyReportCubit cubit) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: BlocProvider<MonthlyReportCubit>.value(
      value: cubit,
      child: const MonthlyReportView(),
    ),
  );
}

Future<void> _pumpStable(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final selectedMonth = ReportMonth(year: 2026, month: 1);

  setUpAll(() {
    registerFallbackValue(MonthlyReportState(selectedMonth: selectedMonth));
    registerFallbackValue(selectedMonth);
    registerFallbackValue(MonthlyReportTab.monthly);
  });

  void stubCubitMethods(MockMonthlyReportCubit cubit) {
    when(() => cubit.changeTab(any())).thenReturn(null);
    when(() => cubit.changeMonth(any())).thenAnswer((_) async {});
    when(() => cubit.retry()).thenAnswer((_) async {});
  }

  MonthlyTrend fakeTrend() {
    final months = List.generate(
      12,
      (i) => ReportMonth(year: 2026, month: i + 1),
    );
    return MonthlyTrend(
      year: 2026,
      selectedMonth: selectedMonth,
      incomeByMonth: {
        for (final m in months) m: Money((m.month * 1000).toDouble()),
      },
      expenseByMonth: {
        for (final m in months) m: Money((m.month * 500).toDouble()),
      },
    );
  }

  MonthlySummary fakeSummary() {
    return MonthlySummary.fromIncomeExpense(
      month: selectedMonth,
      income: Money(5000),
      expense: Money(2500),
      topExpenses: [
        TopExpense(
          transactionId: 1,
          categoryId: 1,
          categoryName: 'Food',
          categoryIcon: 'food',
          amount: Money(1000),
        ),
        TopExpense(
          transactionId: 2,
          categoryId: 2,
          categoryName: 'Transport',
          categoryIcon: 'transport',
          amount: Money(800),
        ),
        TopExpense(
          transactionId: 3,
          categoryId: 3,
          categoryName: 'Entertainment',
          categoryIcon: 'entertainment',
          amount: Money(700),
        ),
      ],
    );
  }

  List<CategoryTotal> fakeExpenseCategories() {
    return [
      CategoryTotal(
        categoryId: 1,
        name: 'Food',
        icon: 'food',
        total: Money(1000),
        percent: 40,
      ),
      CategoryTotal(
        categoryId: 2,
        name: 'Transport',
        icon: 'transport',
        total: Money(800),
        percent: 32,
      ),
      CategoryTotal(
        categoryId: 3,
        name: 'Entertainment',
        icon: 'entertainment',
        total: Money(700),
        percent: 28,
      ),
    ];
  }

  List<CategoryTotal> fakeIncomeCategories() {
    return [
      CategoryTotal(
        categoryId: 10,
        name: 'Salary',
        icon: 'salary',
        total: Money(4000),
        percent: 80,
      ),
      CategoryTotal(
        categoryId: 11,
        name: 'Freelance',
        icon: 'freelance',
        total: Money(1000),
        percent: 20,
      ),
    ];
  }

  group('MonthlyReportView golden', () {
    testWidgets('loading state', (tester) async {
      final cubit = MockMonthlyReportCubit();
      stubCubitMethods(cubit);

      final state = MonthlyReportState(
        selectedMonth: selectedMonth,
        isLoadingTrend: true,
        isLoadingMonthData: true,
      );

      when(() => cubit.state).thenReturn(state);
      whenListen<MonthlyReportState>(
        cubit,
        Stream<MonthlyReportState>.fromIterable([state]),
        initialState: state,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(MonthlyReportView),
        matchesGoldenFile('goldens/monthly_report_loading.png'),
      );
    });

    testWidgets('monthly tab (loaded with data)', (tester) async {
      final cubit = MockMonthlyReportCubit();
      stubCubitMethods(cubit);

      final state = MonthlyReportState(
        tab: MonthlyReportTab.monthly,
        selectedMonth: selectedMonth,
        trend: fakeTrend(),
        summary: fakeSummary(),
        expenseCategories: fakeExpenseCategories(),
        incomeCategories: fakeIncomeCategories(),
        isLoadingTrend: false,
        isLoadingMonthData: false,
      );

      when(() => cubit.state).thenReturn(state);
      whenListen<MonthlyReportState>(
        cubit,
        const Stream<MonthlyReportState>.empty(),
        initialState: state,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(MonthlyReportView),
        matchesGoldenFile('goldens/monthly_report_monthly_tab.png'),
      );
    });

    testWidgets('category tab (loaded with data)', (tester) async {
      final cubit = MockMonthlyReportCubit();
      stubCubitMethods(cubit);

      final state = MonthlyReportState(
        tab: MonthlyReportTab.category,
        selectedMonth: selectedMonth,
        trend: fakeTrend(),
        summary: fakeSummary(),
        expenseCategories: fakeExpenseCategories(),
        incomeCategories: fakeIncomeCategories(),
        isLoadingTrend: false,
        isLoadingMonthData: false,
      );

      when(() => cubit.state).thenReturn(state);
      whenListen<MonthlyReportState>(
        cubit,
        const Stream<MonthlyReportState>.empty(),
        initialState: state,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(MonthlyReportView),
        matchesGoldenFile('goldens/monthly_report_category_tab.png'),
      );
    });

    testWidgets('summary tab (loaded with data)', (tester) async {
      final cubit = MockMonthlyReportCubit();
      stubCubitMethods(cubit);

      final state = MonthlyReportState(
        tab: MonthlyReportTab.summary,
        selectedMonth: selectedMonth,
        trend: fakeTrend(),
        summary: fakeSummary(),
        expenseCategories: fakeExpenseCategories(),
        incomeCategories: fakeIncomeCategories(),
        isLoadingTrend: false,
        isLoadingMonthData: false,
      );

      when(() => cubit.state).thenReturn(state);
      whenListen<MonthlyReportState>(
        cubit,
        const Stream<MonthlyReportState>.empty(),
        initialState: state,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(MonthlyReportView),
        matchesGoldenFile('goldens/monthly_report_summary_tab.png'),
      );
    });

    testWidgets('error state', (tester) async {
      final cubit = MockMonthlyReportCubit();
      stubCubitMethods(cubit);

      final state = MonthlyReportState(
        selectedMonth: selectedMonth,
        isLoadingTrend: false,
        isLoadingMonthData: false,
        errorMessage: 'Failed to load report data',
      );

      when(() => cubit.state).thenReturn(state);
      whenListen<MonthlyReportState>(
        cubit,
        const Stream<MonthlyReportState>.empty(),
        initialState: state,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _pumpStable(tester);

      await expectLater(
        find.byType(MonthlyReportView),
        matchesGoldenFile('goldens/monthly_report_error.png'),
      );
    });
  });
}
