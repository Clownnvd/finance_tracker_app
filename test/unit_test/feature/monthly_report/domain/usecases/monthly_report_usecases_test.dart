import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/monthly_report/domain/entities/category_total.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/month_total.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/top_expense.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/repositories/report_repository.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/usecases/get_category_breakdown.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/usecases/get_monthly_summary.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/usecases/get_monthly_trend.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/money.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/report_month.dart';

class MockMonthlyReportRepository extends Mock
    implements MonthlyReportRepository {}

void main() {
  late MockMonthlyReportRepository mockRepo;

  const testMonth = ReportMonth(year: 2024, month: 5);

  setUp(() {
    mockRepo = MockMonthlyReportRepository();
  });

  setUpAll(() {
    registerFallbackValue(testMonth);
    registerFallbackValue(MonthTotalType.income);
  });

  group('GetMonthlySummary', () {
    late GetMonthlySummary usecase;

    setUp(() {
      usecase = GetMonthlySummary(mockRepo);
    });

    test('returns MonthlySummary with income, expense, balance, and top expenses',
        () async {
      when(() => mockRepo.getMonthTotal(
            month: any(named: 'month'),
            type: MonthTotalType.income,
          )).thenAnswer((_) async => Money(10000));

      when(() => mockRepo.getMonthTotal(
            month: any(named: 'month'),
            type: MonthTotalType.expense,
          )).thenAnswer((_) async => Money(6000));

      when(() => mockRepo.getTopExpenses(
            month: any(named: 'month'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => [
            TopExpense(
              transactionId: 1,
              categoryId: 1,
              categoryName: 'Food',
              amount: Money(500),
            ),
          ]);

      final result = await usecase.call(month: testMonth, topLimit: 3);

      expect(result.income.value, 10000);
      expect(result.expense.value, 6000);
      expect(result.balance.value, 4000);
      expect(result.topExpenses, hasLength(1));

      verify(() => mockRepo.getMonthTotal(
            month: testMonth,
            type: MonthTotalType.income,
          )).called(1);
      verify(() => mockRepo.getMonthTotal(
            month: testMonth,
            type: MonthTotalType.expense,
          )).called(1);
      verify(() => mockRepo.getTopExpenses(
            month: testMonth,
            limit: 3,
          )).called(1);
    });

    test('uses default topLimit of 3', () async {
      when(() => mockRepo.getMonthTotal(
            month: any(named: 'month'),
            type: any(named: 'type'),
          )).thenAnswer((_) async => Money.zero);

      when(() => mockRepo.getTopExpenses(
            month: any(named: 'month'),
            limit: 3,
          )).thenAnswer((_) async => []);

      await usecase.call(month: testMonth);

      verify(() => mockRepo.getTopExpenses(
            month: testMonth,
            limit: 3,
          )).called(1);
    });

    test('propagates exception from repository', () async {
      when(() => mockRepo.getMonthTotal(
            month: any(named: 'month'),
            type: any(named: 'type'),
          )).thenThrow(Exception('Network error'));

      expect(
        () => usecase.call(month: testMonth),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('GetCategoryBreakdown', () {
    late GetCategoryBreakdown usecase;

    setUp(() {
      usecase = GetCategoryBreakdown(mockRepo);
    });

    test('returns list of CategoryTotal for expenses', () async {
      when(() => mockRepo.getCategoryTotals(
            month: any(named: 'month'),
            type: any(named: 'type'),
          )).thenAnswer((_) async => [
            CategoryTotal(
              categoryId: 1,
              name: 'Food',
              total: Money(3000),
              percent: 50.0,
            ),
            CategoryTotal(
              categoryId: 2,
              name: 'Shopping',
              total: Money(3000),
              percent: 50.0,
            ),
          ]);

      final result = await usecase.call(
        month: testMonth,
        type: MonthTotalType.expense,
      );

      expect(result, hasLength(2));
      expect(result[0].name, 'Food');
      expect(result[1].name, 'Shopping');
      verify(() => mockRepo.getCategoryTotals(
            month: testMonth,
            type: MonthTotalType.expense,
          )).called(1);
    });

    test('returns list of CategoryTotal for income', () async {
      when(() => mockRepo.getCategoryTotals(
            month: any(named: 'month'),
            type: any(named: 'type'),
          )).thenAnswer((_) async => [
            CategoryTotal(
              categoryId: 1,
              name: 'Salary',
              total: Money(8000),
              percent: 80.0,
            ),
            CategoryTotal(
              categoryId: 2,
              name: 'Freelance',
              total: Money(2000),
              percent: 20.0,
            ),
          ]);

      final result = await usecase.call(
        month: testMonth,
        type: MonthTotalType.income,
      );

      expect(result, hasLength(2));
      verify(() => mockRepo.getCategoryTotals(
            month: testMonth,
            type: MonthTotalType.income,
          )).called(1);
    });

    test('returns empty list when no categories', () async {
      when(() => mockRepo.getCategoryTotals(
            month: any(named: 'month'),
            type: any(named: 'type'),
          )).thenAnswer((_) async => []);

      final result = await usecase.call(
        month: testMonth,
        type: MonthTotalType.expense,
      );

      expect(result, isEmpty);
    });

    test('propagates exception from repository', () async {
      when(() => mockRepo.getCategoryTotals(
            month: any(named: 'month'),
            type: any(named: 'type'),
          )).thenThrow(Exception('Network error'));

      expect(
        () => usecase.call(month: testMonth, type: MonthTotalType.expense),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('GetMonthlyTrend', () {
    late GetMonthlyTrend usecase;

    setUp(() {
      usecase = GetMonthlyTrend(mockRepo);
    });

    test('returns MonthlyTrend with income and expense by month', () async {
      when(() => mockRepo.getYearTotals(
            year: any(named: 'year'),
            type: MonthTotalType.income,
          )).thenAnswer((_) async => [
            MonthTotal(
              month: const ReportMonth(year: 2024, month: 1),
              amount: Money(5000),
              type: MonthTotalType.income,
            ),
            MonthTotal(
              month: const ReportMonth(year: 2024, month: 2),
              amount: Money(6000),
              type: MonthTotalType.income,
            ),
          ]);

      when(() => mockRepo.getYearTotals(
            year: any(named: 'year'),
            type: MonthTotalType.expense,
          )).thenAnswer((_) async => [
            MonthTotal(
              month: const ReportMonth(year: 2024, month: 1),
              amount: Money(3000),
              type: MonthTotalType.expense,
            ),
          ]);

      final result = await usecase.call(
        year: 2024,
        selectedMonth: testMonth,
      );

      expect(result.year, 2024);
      expect(result.selectedMonth, testMonth);
      expect(result.incomeByMonth.length, 12); // Pre-filled all 12 months
      expect(result.expenseByMonth.length, 12);

      // Check actual data
      expect(
        result.incomeByMonth[const ReportMonth(year: 2024, month: 1)]?.value,
        5000,
      );
      expect(
        result.incomeByMonth[const ReportMonth(year: 2024, month: 2)]?.value,
        6000,
      );

      // Check missing month defaults to zero
      expect(
        result.incomeByMonth[const ReportMonth(year: 2024, month: 3)]?.value,
        0,
      );
    });

    test('fills all 12 months with zero for missing data', () async {
      when(() => mockRepo.getYearTotals(
            year: any(named: 'year'),
            type: any(named: 'type'),
          )).thenAnswer((_) async => []);

      final result = await usecase.call(
        year: 2024,
        selectedMonth: testMonth,
      );

      expect(result.incomeByMonth.length, 12);
      expect(result.expenseByMonth.length, 12);

      for (var m = 1; m <= 12; m++) {
        expect(
          result.incomeByMonth[ReportMonth(year: 2024, month: m)],
          Money.zero,
        );
        expect(
          result.expenseByMonth[ReportMonth(year: 2024, month: m)],
          Money.zero,
        );
      }
    });

    test('calls repository for both income and expense types', () async {
      when(() => mockRepo.getYearTotals(
            year: any(named: 'year'),
            type: any(named: 'type'),
          )).thenAnswer((_) async => []);

      await usecase.call(year: 2024, selectedMonth: testMonth);

      verify(() => mockRepo.getYearTotals(
            year: 2024,
            type: MonthTotalType.income,
          )).called(1);
      verify(() => mockRepo.getYearTotals(
            year: 2024,
            type: MonthTotalType.expense,
          )).called(1);
    });

    test('propagates exception from repository', () async {
      when(() => mockRepo.getYearTotals(
            year: any(named: 'year'),
            type: any(named: 'type'),
          )).thenThrow(Exception('Network error'));

      expect(
        () => usecase.call(year: 2024, selectedMonth: testMonth),
        throwsA(isA<Exception>()),
      );
    });
  });
}
