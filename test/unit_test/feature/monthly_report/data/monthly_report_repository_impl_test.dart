import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';
import 'package:finance_tracker_app/feature/monthly_report/data/models/report_remote_data_source.dart';
import 'package:finance_tracker_app/feature/monthly_report/data/repositories/monthly_report_repository_impl.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/month_total.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/money.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/report_month.dart';

class MockRemoteDataSource extends Mock
    implements MonthlyReportRemoteDataSource {}

class MockUserIdLocalDataSource extends Mock implements UserIdLocalDataSource {}

void main() {
  late MockRemoteDataSource mockRemote;
  late MockUserIdLocalDataSource mockUserIdLocal;
  late MonthlyReportRepositoryImpl repo;

  const testUserId = 'user-123';
  const testMonth = ReportMonth(year: 2024, month: 5);

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockUserIdLocal = MockUserIdLocalDataSource();
    repo = MonthlyReportRepositoryImpl(
      remote: mockRemote,
      userIdLocal: mockUserIdLocal,
    );
  });

  group('MonthlyReportRepositoryImpl', () {
    group('getYearTotals', () {
      test('returns list of MonthTotal on success', () async {
        when(() => mockRemote.fetchMonthTotals(
              type: any(named: 'type'),
              year: any(named: 'year'),
            )).thenAnswer((_) async => [
              {
                'user_id': testUserId,
                'month': '2024-01-01',
                'total': 5000.0,
                'type': 'INCOME',
              },
              {
                'user_id': testUserId,
                'month': '2024-02-01',
                'total': 6000.0,
                'type': 'INCOME',
              },
            ]);

        final result = await repo.getYearTotals(
          year: 2024,
          type: MonthTotalType.income,
        );

        expect(result, hasLength(2));
        expect(result[0].amount.value, 5000.0);
        expect(result[1].amount.value, 6000.0);
        verify(() => mockRemote.fetchMonthTotals(
              type: 'INCOME',
              year: 2024,
            )).called(1);
      });

      test('returns empty list when no data', () async {
        when(() => mockRemote.fetchMonthTotals(
              type: any(named: 'type'),
              year: any(named: 'year'),
            )).thenAnswer((_) async => []);

        final result = await repo.getYearTotals(
          year: 2024,
          type: MonthTotalType.expense,
        );

        expect(result, isEmpty);
      });

      test('throws mapped exception on error', () async {
        when(() => mockRemote.fetchMonthTotals(
              type: any(named: 'type'),
              year: any(named: 'year'),
            )).thenThrow(Exception('Network error'));

        expect(
          () => repo.getYearTotals(year: 2024, type: MonthTotalType.income),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getMonthTotal', () {
      test('returns Money amount on success', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.fetchMonthTotalsViewFiltered(
              uid: any(named: 'uid'),
              monthStartIso: any(named: 'monthStartIso'),
              type: any(named: 'type'),
            )).thenAnswer((_) async => [
              {'user_id': testUserId, 'month': '2024-05-01', 'total': 12500.0, 'type': 'INCOME'},
            ]);

        final result = await repo.getMonthTotal(
          month: testMonth,
          type: MonthTotalType.income,
        );

        expect(result.value, 12500.0);
      });

      test('returns Money.zero when no data', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.fetchMonthTotalsViewFiltered(
              uid: any(named: 'uid'),
              monthStartIso: any(named: 'monthStartIso'),
              type: any(named: 'type'),
            )).thenAnswer((_) async => []);

        final result = await repo.getMonthTotal(
          month: testMonth,
          type: MonthTotalType.expense,
        );

        expect(result, Money.zero);
      });

      test('throws when userId is missing', () async {
        when(() => mockUserIdLocal.getUserId()).thenAnswer((_) async => null);

        expect(
          () => repo.getMonthTotal(month: testMonth, type: MonthTotalType.income),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getCategoryTotals', () {
      test('returns list of CategoryTotal on success', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.fetchCategoryTotals(
              uid: any(named: 'uid'),
              startDateIso: any(named: 'startDateIso'),
              endDateIso: any(named: 'endDateIso'),
              catType: any(named: 'catType'),
            )).thenAnswer((_) async => [
              {
                'category_id': 1,
                'name': 'Food',
                'total': 3000.0,
                'percent': 60.0,
              },
              {
                'category_id': 2,
                'name': 'Shopping',
                'total': 2000.0,
                'percent': 40.0,
              },
            ]);

        final result = await repo.getCategoryTotals(
          month: testMonth,
          type: MonthTotalType.expense,
        );

        expect(result, hasLength(2));
        expect(result[0].name, 'Food');
        expect(result[0].total.value, 3000.0);
      });

      test('returns empty list when no data', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.fetchCategoryTotals(
              uid: any(named: 'uid'),
              startDateIso: any(named: 'startDateIso'),
              endDateIso: any(named: 'endDateIso'),
              catType: any(named: 'catType'),
            )).thenAnswer((_) async => []);

        final result = await repo.getCategoryTotals(
          month: testMonth,
          type: MonthTotalType.income,
        );

        expect(result, isEmpty);
      });
    });

    group('getTopExpenses', () {
      test('returns list of TopExpense on success', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.fetchTopExpenses(
              uid: any(named: 'uid'),
              startDateIso: any(named: 'startDateIso'),
              endDateIso: any(named: 'endDateIso'),
              limit: any(named: 'limit'),
            )).thenAnswer((_) async => [
              {
                'id': 1,
                'amount': 500.0,
                'type': 'EXPENSE',
                'date': '2024-05-15',
                'note': 'Grocery shopping',
                'category_id': 1,
                'categories': {'name': 'Food', 'icon': 'food'},
              },
              {
                'id': 2,
                'amount': 300.0,
                'type': 'EXPENSE',
                'date': '2024-05-10',
                'note': 'Gas',
                'category_id': 2,
                'categories': {'name': 'Transportation', 'icon': 'car'},
              },
            ]);

        final result = await repo.getTopExpenses(month: testMonth);

        expect(result, hasLength(2));
        expect(result[0].amount.value, 500.0);
        expect(result[0].categoryName, 'Food');
      });

      test('uses default limit of 3', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.fetchTopExpenses(
              uid: any(named: 'uid'),
              startDateIso: any(named: 'startDateIso'),
              endDateIso: any(named: 'endDateIso'),
              limit: 3,
            )).thenAnswer((_) async => []);

        await repo.getTopExpenses(month: testMonth);

        verify(() => mockRemote.fetchTopExpenses(
              uid: testUserId,
              startDateIso: testMonth.startIso,
              endDateIso: testMonth.endIso,
              limit: 3,
            )).called(1);
      });

      test('returns empty list when no expenses', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.fetchTopExpenses(
              uid: any(named: 'uid'),
              startDateIso: any(named: 'startDateIso'),
              endDateIso: any(named: 'endDateIso'),
              limit: any(named: 'limit'),
            )).thenAnswer((_) async => []);

        final result = await repo.getTopExpenses(month: testMonth);

        expect(result, isEmpty);
      });
    });
  });
}
