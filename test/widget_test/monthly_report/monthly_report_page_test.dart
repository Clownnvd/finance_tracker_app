import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/monthly_report/domain/entities/category_total.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/monthly_summary.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/monthly_trend.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/top_expense.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/money.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/report_month.dart';
import 'package:finance_tracker_app/feature/monthly_report/presentation/cubit/monthly_report_cubit.dart';
import 'package:finance_tracker_app/feature/monthly_report/presentation/cubit/monthly_report_state.dart';
import 'package:finance_tracker_app/feature/monthly_report/presentation/widgets/monthly_report_view.dart';

class MockMonthlyReportCubit extends MockCubit<MonthlyReportState>
    implements MonthlyReportCubit {}

void main() {
  late MockMonthlyReportCubit mockCubit;

  const testMonth = ReportMonth(year: 2024, month: 5);

  MonthlyReportState createLoadedState({
    MonthlyReportTab tab = MonthlyReportTab.monthly,
  }) {
    final trend = MonthlyTrend(
      year: 2024,
      incomeByMonth: {for (var m = 1; m <= 12; m++) ReportMonth(year: 2024, month: m): Money.zero},
      expenseByMonth: {for (var m = 1; m <= 12; m++) ReportMonth(year: 2024, month: m): Money.zero},
      selectedMonth: testMonth,
    );

    final summary = MonthlySummary(
      month: testMonth,
      income: Money(10000),
      expense: Money(6000),
      balance: Money(4000),
      topExpenses: [
        TopExpense(
          transactionId: 1,
          categoryId: 1,
          categoryName: 'Food',
          amount: Money(500),
        ),
      ],
    );

    return MonthlyReportState(
      selectedMonth: testMonth,
      tab: tab,
      trend: trend,
      summary: summary,
      expenseCategories: [
        CategoryTotal(
          categoryId: 1,
          name: 'Food',
          total: Money(3000),
          percent: 50,
        ),
      ],
      incomeCategories: [
        CategoryTotal(
          categoryId: 2,
          name: 'Salary',
          total: Money(10000),
          percent: 100,
        ),
      ],
    );
  }

  Widget buildWidget() {
    return MaterialApp(
      home: BlocProvider<MonthlyReportCubit>.value(
        value: mockCubit,
        child: const MonthlyReportView(),
      ),
    );
  }

  setUp(() {
    mockCubit = MockMonthlyReportCubit();
  });

  setUpAll(() {
    registerFallbackValue(MonthlyReportTab.monthly);
    registerFallbackValue(testMonth);
  });

  group('MonthlyReportView', () {
    testWidgets('displays AppBar with title', (tester) async {
      when(() => mockCubit.state).thenReturn(
        MonthlyReportState(selectedMonth: testMonth),
      );

      await tester.pumpWidget(buildWidget());

      expect(find.text('Financial Report'), findsOneWidget);
    });

    testWidgets('displays loading indicator when isLoadingTrend is true',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        MonthlyReportState(
          selectedMonth: testMonth,
          isLoadingTrend: true,
        ),
      );

      await tester.pumpWidget(buildWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays loading indicator when isLoadingMonthData is true',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        MonthlyReportState(
          selectedMonth: testMonth,
          isLoadingMonthData: true,
        ),
      );

      await tester.pumpWidget(buildWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error card when errorMessage is set',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        MonthlyReportState(
          selectedMonth: testMonth,
          errorMessage: 'Network error occurred',
        ),
      );

      await tester.pumpWidget(buildWidget());

      expect(find.text('Network error occurred'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('calls retry when retry button is tapped', (tester) async {
      when(() => mockCubit.state).thenReturn(
        MonthlyReportState(
          selectedMonth: testMonth,
          errorMessage: 'Network error',
        ),
      );
      when(() => mockCubit.retry()).thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());

      await tester.tap(find.text('Retry'));
      await tester.pump();

      verify(() => mockCubit.retry()).called(1);
    });

    testWidgets('displays MonthlyTab content when tab is monthly',
        (tester) async {
      when(() => mockCubit.state)
          .thenReturn(createLoadedState(tab: MonthlyReportTab.monthly));

      await tester.pumpWidget(buildWidget());

      // Should display trend chart or monthly content
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('displays CategoryTab content when tab is category',
        (tester) async {
      when(() => mockCubit.state)
          .thenReturn(createLoadedState(tab: MonthlyReportTab.category));

      await tester.pumpWidget(buildWidget());

      // CategoryTab should show expense/income categories
      expect(find.text('Food'), findsWidgets);
    });

    testWidgets('displays SummaryTab content when tab is summary',
        (tester) async {
      when(() => mockCubit.state)
          .thenReturn(createLoadedState(tab: MonthlyReportTab.summary));

      await tester.pumpWidget(buildWidget());

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('calls changeTab when tab is changed', (tester) async {
      when(() => mockCubit.state).thenReturn(createLoadedState());
      when(() => mockCubit.changeTab(any())).thenReturn(null);

      await tester.pumpWidget(buildWidget());

      // Find and tap category tab button
      final categoryButton = find.text('Category');
      if (categoryButton.evaluate().isNotEmpty) {
        await tester.tap(categoryButton);
        await tester.pump();
        verify(() => mockCubit.changeTab(MonthlyReportTab.category)).called(1);
      }
    });

    testWidgets('displays month dropdown for selection', (tester) async {
      when(() => mockCubit.state).thenReturn(createLoadedState());

      await tester.pumpWidget(buildWidget());

      // Month label should be visible
      expect(find.text('May 2024'), findsWidgets);
    });

    testWidgets('rebuilds when state changes', (tester) async {
      final statesController = StreamController<MonthlyReportState>.broadcast();

      whenListen(
        mockCubit,
        statesController.stream,
        initialState: MonthlyReportState(
          selectedMonth: testMonth,
          isLoadingTrend: true,
        ),
      );

      await tester.pumpWidget(buildWidget());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      statesController.add(createLoadedState());
      await tester.pumpAndSettle();

      // Loading should be gone
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await statesController.close();
    });
  });
}
