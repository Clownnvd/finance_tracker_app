import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/monthly_report/domain/entities/category_total.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/monthly_summary.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/monthly_trend.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/month_total.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/usecases/get_category_breakdown.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/usecases/get_monthly_summary.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/usecases/get_monthly_trend.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/money.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/report_month.dart';
import 'package:finance_tracker_app/feature/monthly_report/presentation/cubit/monthly_report_cubit.dart';
import 'package:finance_tracker_app/feature/monthly_report/presentation/cubit/monthly_report_state.dart';

class MockGetMonthlyTrend extends Mock implements GetMonthlyTrend {}

class MockGetMonthlySummary extends Mock implements GetMonthlySummary {}

class MockGetCategoryBreakdown extends Mock implements GetCategoryBreakdown {}

void main() {
  late MockGetMonthlyTrend mockGetMonthlyTrend;
  late MockGetMonthlySummary mockGetMonthlySummary;
  late MockGetCategoryBreakdown mockGetCategoryBreakdown;
  late MonthlyReportCubit cubit;

  final testMonth = ReportMonth(year: 2026, month: 1);

  MonthlyTrend testTrend({int year = 2026, ReportMonth? selectedMonth}) {
    final sm = selectedMonth ?? ReportMonth(year: year, month: 1);
    return MonthlyTrend(
      year: year,
      incomeByMonth: {
        ReportMonth(year: year, month: 1): Money(5000),
        ReportMonth(year: year, month: 2): Money(6000),
      },
      expenseByMonth: {
        ReportMonth(year: year, month: 1): Money(3000),
        ReportMonth(year: year, month: 2): Money(2500),
      },
      selectedMonth: sm,
    );
  }

  MonthlySummary testSummary({ReportMonth? month}) {
    final m = month ?? testMonth;
    return MonthlySummary(
      month: m,
      income: Money(5000),
      expense: Money(3000),
      balance: Money(2000),
      topExpenses: const [],
    );
  }

  List<CategoryTotal> testCategories() {
    return [
      CategoryTotal(
        categoryId: 1,
        name: 'Food',
        total: Money(1500),
        percent: 50,
      ),
      CategoryTotal(
        categoryId: 2,
        name: 'Housing',
        total: Money(1500),
        percent: 50,
      ),
    ];
  }

  setUpAll(() {
    registerFallbackValue(testMonth);
    registerFallbackValue(MonthTotalType.expense);
  });

  setUp(() {
    mockGetMonthlyTrend = MockGetMonthlyTrend();
    mockGetMonthlySummary = MockGetMonthlySummary();
    mockGetCategoryBreakdown = MockGetCategoryBreakdown();

    cubit = MonthlyReportCubit(
      getMonthlyTrend: mockGetMonthlyTrend,
      getMonthlySummary: mockGetMonthlySummary,
      getCategoryBreakdown: mockGetCategoryBreakdown,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('MonthlyReportCubit', () {
    group('init', () {
      blocTest<MonthlyReportCubit, MonthlyReportState>(
        'loads trend and month data in parallel on init',
        build: () {
          when(() => mockGetMonthlyTrend(
                year: any(named: 'year'),
                selectedMonth: any(named: 'selectedMonth'),
              )).thenAnswer((_) async => testTrend());

          when(() => mockGetMonthlySummary(
                month: any(named: 'month'),
                topLimit: any(named: 'topLimit'),
              )).thenAnswer((_) async => testSummary());

          when(() => mockGetCategoryBreakdown(
                month: any(named: 'month'),
                type: any(named: 'type'),
              )).thenAnswer((_) async => testCategories());

          return cubit;
        },
        act: (c) => c.init(),
        verify: (_) {
          verify(() => mockGetMonthlyTrend(
                year: any(named: 'year'),
                selectedMonth: any(named: 'selectedMonth'),
              )).called(1);
          verify(() => mockGetMonthlySummary(
                month: any(named: 'month'),
                topLimit: 3,
              )).called(1);
          // Called twice: once for expense, once for income
          verify(() => mockGetCategoryBreakdown(
                month: any(named: 'month'),
                type: any(named: 'type'),
              )).called(2);
        },
      );
    });

    group('changeTab', () {
      blocTest<MonthlyReportCubit, MonthlyReportState>(
        'changes tab and clears error',
        build: () => cubit,
        seed: () => MonthlyReportState(
          selectedMonth: testMonth,
          tab: MonthlyReportTab.monthly,
          errorMessage: 'Some error',
        ),
        act: (c) => c.changeTab(MonthlyReportTab.category),
        expect: () => [
          isA<MonthlyReportState>()
              .having((s) => s.tab, 'tab', MonthlyReportTab.category)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
        ],
      );

      blocTest<MonthlyReportCubit, MonthlyReportState>(
        'does nothing when tab is the same',
        build: () => cubit,
        seed: () => MonthlyReportState(
          selectedMonth: testMonth,
          tab: MonthlyReportTab.monthly,
        ),
        act: (c) => c.changeTab(MonthlyReportTab.monthly),
        expect: () => <MonthlyReportState>[],
      );
    });

    group('changeMonth', () {
      blocTest<MonthlyReportCubit, MonthlyReportState>(
        'does nothing when month is the same',
        build: () => cubit,
        seed: () => MonthlyReportState(selectedMonth: testMonth),
        act: (c) => c.changeMonth(testMonth),
        expect: () => <MonthlyReportState>[],
      );

      blocTest<MonthlyReportCubit, MonthlyReportState>(
        'reloads trend when year changes',
        build: () {
          final newMonth = ReportMonth(year: 2025, month: 6);
          when(() => mockGetMonthlyTrend(
                year: 2025,
                selectedMonth: newMonth,
              )).thenAnswer((_) async => testTrend(year: 2025, selectedMonth: newMonth));

          when(() => mockGetMonthlySummary(
                month: any(named: 'month'),
                topLimit: any(named: 'topLimit'),
              )).thenAnswer((_) async => testSummary(month: newMonth));

          when(() => mockGetCategoryBreakdown(
                month: any(named: 'month'),
                type: any(named: 'type'),
              )).thenAnswer((_) async => testCategories());

          return cubit;
        },
        seed: () => MonthlyReportState(
          selectedMonth: testMonth,
          trend: testTrend(),
        ),
        act: (c) => c.changeMonth(ReportMonth(year: 2025, month: 6)),
        verify: (_) {
          verify(() => mockGetMonthlyTrend(
                year: 2025,
                selectedMonth: any(named: 'selectedMonth'),
              )).called(1);
        },
      );

      blocTest<MonthlyReportCubit, MonthlyReportState>(
        'does not reload trend when same year, different month',
        build: () {
          final newMonth = ReportMonth(year: 2026, month: 6);

          when(() => mockGetMonthlySummary(
                month: any(named: 'month'),
                topLimit: any(named: 'topLimit'),
              )).thenAnswer((_) async => testSummary(month: newMonth));

          when(() => mockGetCategoryBreakdown(
                month: any(named: 'month'),
                type: any(named: 'type'),
              )).thenAnswer((_) async => testCategories());

          return cubit;
        },
        seed: () => MonthlyReportState(
          selectedMonth: testMonth,
          trend: testTrend(),
        ),
        act: (c) => c.changeMonth(ReportMonth(year: 2026, month: 6)),
        verify: (_) {
          verifyNever(() => mockGetMonthlyTrend(
                year: any(named: 'year'),
                selectedMonth: any(named: 'selectedMonth'),
              ));
        },
      );
    });

    group('loadTrend', () {
      blocTest<MonthlyReportCubit, MonthlyReportState>(
        'emits loading then data on success',
        build: () {
          when(() => mockGetMonthlyTrend(
                year: any(named: 'year'),
                selectedMonth: any(named: 'selectedMonth'),
              )).thenAnswer((_) async => testTrend());
          return cubit;
        },
        seed: () => MonthlyReportState(selectedMonth: testMonth),
        act: (c) => c.loadTrend(year: 2026),
        expect: () => [
          isA<MonthlyReportState>()
              .having((s) => s.isLoadingTrend, 'isLoadingTrend', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<MonthlyReportState>()
              .having((s) => s.isLoadingTrend, 'isLoadingTrend', false)
              .having((s) => s.trend, 'trend', isNotNull),
        ],
      );

      blocTest<MonthlyReportCubit, MonthlyReportState>(
        'emits error on failure',
        build: () {
          when(() => mockGetMonthlyTrend(
                year: any(named: 'year'),
                selectedMonth: any(named: 'selectedMonth'),
              )).thenThrow(Exception('Network error'));
          return cubit;
        },
        seed: () => MonthlyReportState(selectedMonth: testMonth),
        act: (c) => c.loadTrend(year: 2026),
        expect: () => [
          isA<MonthlyReportState>()
              .having((s) => s.isLoadingTrend, 'isLoadingTrend', true),
          isA<MonthlyReportState>()
              .having((s) => s.isLoadingTrend, 'isLoadingTrend', false)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('loadMonthData', () {
      blocTest<MonthlyReportCubit, MonthlyReportState>(
        'emits loading then data on success',
        build: () {
          when(() => mockGetMonthlySummary(
                month: any(named: 'month'),
                topLimit: any(named: 'topLimit'),
              )).thenAnswer((_) async => testSummary());

          when(() => mockGetCategoryBreakdown(
                month: any(named: 'month'),
                type: any(named: 'type'),
              )).thenAnswer((_) async => testCategories());

          return cubit;
        },
        seed: () => MonthlyReportState(selectedMonth: testMonth),
        act: (c) => c.loadMonthData(month: testMonth),
        expect: () => [
          isA<MonthlyReportState>()
              .having((s) => s.isLoadingMonthData, 'isLoadingMonthData', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<MonthlyReportState>()
              .having((s) => s.isLoadingMonthData, 'isLoadingMonthData', false)
              .having((s) => s.summary, 'summary', isNotNull)
              .having((s) => s.expenseCategories.length, 'expenseCategories', 2)
              .having((s) => s.incomeCategories.length, 'incomeCategories', 2),
        ],
      );

      blocTest<MonthlyReportCubit, MonthlyReportState>(
        'emits error on failure',
        build: () {
          when(() => mockGetMonthlySummary(
                month: any(named: 'month'),
                topLimit: any(named: 'topLimit'),
              )).thenThrow(Exception('Failed'));
          return cubit;
        },
        seed: () => MonthlyReportState(selectedMonth: testMonth),
        act: (c) => c.loadMonthData(month: testMonth),
        expect: () => [
          isA<MonthlyReportState>()
              .having((s) => s.isLoadingMonthData, 'isLoadingMonthData', true),
          isA<MonthlyReportState>()
              .having((s) => s.isLoadingMonthData, 'isLoadingMonthData', false)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('clearError', () {
      blocTest<MonthlyReportCubit, MonthlyReportState>(
        'clears error message when error exists',
        build: () => cubit,
        seed: () => MonthlyReportState(
          selectedMonth: testMonth,
          errorMessage: 'Some error',
        ),
        act: (c) => c.clearError(),
        expect: () => [
          isA<MonthlyReportState>()
              .having((s) => s.errorMessage, 'errorMessage', isNull),
        ],
      );

      blocTest<MonthlyReportCubit, MonthlyReportState>(
        'does nothing when no error',
        build: () => cubit,
        seed: () => MonthlyReportState(
          selectedMonth: testMonth,
          errorMessage: null,
        ),
        act: (c) => c.clearError(),
        expect: () => <MonthlyReportState>[],
      );
    });

    group('retry', () {
      blocTest<MonthlyReportCubit, MonthlyReportState>(
        'reloads both trend and month data',
        build: () {
          when(() => mockGetMonthlyTrend(
                year: any(named: 'year'),
                selectedMonth: any(named: 'selectedMonth'),
              )).thenAnswer((_) async => testTrend());

          when(() => mockGetMonthlySummary(
                month: any(named: 'month'),
                topLimit: any(named: 'topLimit'),
              )).thenAnswer((_) async => testSummary());

          when(() => mockGetCategoryBreakdown(
                month: any(named: 'month'),
                type: any(named: 'type'),
              )).thenAnswer((_) async => testCategories());

          return cubit;
        },
        seed: () => MonthlyReportState(selectedMonth: testMonth),
        act: (c) => c.retry(),
        verify: (_) {
          verify(() => mockGetMonthlyTrend(
                year: any(named: 'year'),
                selectedMonth: any(named: 'selectedMonth'),
              )).called(1);
          verify(() => mockGetMonthlySummary(
                month: any(named: 'month'),
                topLimit: any(named: 'topLimit'),
              )).called(1);
        },
      );
    });
  });
}
