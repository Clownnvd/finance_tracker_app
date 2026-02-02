import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';
import 'package:finance_tracker_app/feature/budgets/data/datasources/budgets_remote_data_source.dart';
import 'package:finance_tracker_app/feature/budgets/data/repositories/budgets_repository_impl.dart';

class MockBudgetsRemoteDataSource extends Mock
    implements BudgetsRemoteDataSource {}

class MockUserIdLocalDataSource extends Mock implements UserIdLocalDataSource {}

void main() {
  late MockBudgetsRemoteDataSource mockRemote;
  late MockUserIdLocalDataSource mockUserIdLocal;
  late BudgetsRepositoryImpl repo;

  setUp(() {
    mockRemote = MockBudgetsRemoteDataSource();
    mockUserIdLocal = MockUserIdLocalDataSource();

    repo = BudgetsRepositoryImpl(
      remote: mockRemote,
      userIdLocal: mockUserIdLocal,
    );
  });

  Map<String, dynamic> budgetJson({
    int id = 1,
    String userId = 'user-1',
    int categoryId = 1,
    double amount = 1000,
    int month = 1,
  }) {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'month': month,
    };
  }

  group('BudgetsRepositoryImpl', () {
    group('getMyBudgets', () {
      test('returns list of Budget entities on success', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => 'user-1');

        when(() => mockRemote.getMyBudgets(uid: 'user-1')).thenAnswer(
          (_) async => [
            budgetJson(id: 1, categoryId: 1, amount: 1000, month: 1),
            budgetJson(id: 2, categoryId: 2, amount: 2000, month: 2),
          ],
        );

        final result = await repo.getMyBudgets();

        expect(result.length, 2);
        expect(result[0].id, 1);
        expect(result[0].categoryId, 1);
        expect(result[0].amount, 1000);
        expect(result[0].month, 1);
        expect(result[1].id, 2);
        expect(result[1].amount, 2000);

        verify(() => mockUserIdLocal.getUserId()).called(1);
        verify(() => mockRemote.getMyBudgets(uid: 'user-1')).called(1);
      });

      test('throws exception when userId is null', () async {
        when(() => mockUserIdLocal.getUserId()).thenAnswer((_) async => null);

        expect(
          () => repo.getMyBudgets(),
          throwsA(isA<Exception>()),
        );

        verifyNever(() => mockRemote.getMyBudgets(uid: any(named: 'uid')));
      });

      test('throws exception when userId is empty', () async {
        when(() => mockUserIdLocal.getUserId()).thenAnswer((_) async => '   ');

        expect(
          () => repo.getMyBudgets(),
          throwsA(isA<Exception>()),
        );

        verifyNever(() => mockRemote.getMyBudgets(uid: any(named: 'uid')));
      });

      test('throws exception when remote throws', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => 'user-1');
        when(() => mockRemote.getMyBudgets(uid: 'user-1'))
            .thenThrow(Exception('Network error'));

        expect(
          () => repo.getMyBudgets(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('createBudget', () {
      test('creates budget and returns Budget entity on success', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => 'user-1');

        when(() => mockRemote.createBudget(
              uid: any(named: 'uid'),
              categoryId: any(named: 'categoryId'),
              amount: any(named: 'amount'),
              month: any(named: 'month'),
            )).thenAnswer(
          (_) async => [budgetJson(id: 5, categoryId: 3, amount: 500, month: 6)],
        );

        final result = await repo.createBudget(
          categoryId: 3,
          amount: 500,
          month: 6,
        );

        expect(result.id, 5);
        expect(result.categoryId, 3);
        expect(result.amount, 500);
        expect(result.month, 6);
        expect(result.userId, 'user-1');

        verify(() => mockRemote.createBudget(
              uid: 'user-1',
              categoryId: 3,
              amount: 500,
              month: 6,
            )).called(1);
      });

      test('throws exception when remote returns empty response', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => 'user-1');

        when(() => mockRemote.createBudget(
              uid: any(named: 'uid'),
              categoryId: any(named: 'categoryId'),
              amount: any(named: 'amount'),
              month: any(named: 'month'),
            )).thenAnswer((_) async => []);

        expect(
          () => repo.createBudget(categoryId: 1, amount: 100, month: 1),
          throwsA(isA<Exception>()),
        );
      });

      test('throws exception when userId is missing', () async {
        when(() => mockUserIdLocal.getUserId()).thenAnswer((_) async => null);

        expect(
          () => repo.createBudget(categoryId: 1, amount: 100, month: 1),
          throwsA(isA<Exception>()),
        );

        verifyNever(() => mockRemote.createBudget(
              uid: any(named: 'uid'),
              categoryId: any(named: 'categoryId'),
              amount: any(named: 'amount'),
              month: any(named: 'month'),
            ));
      });
    });

    group('updateBudget', () {
      test('updates budget and returns Budget entity on success', () async {
        when(() => mockRemote.updateBudget(
              budgetId: any(named: 'budgetId'),
              amount: any(named: 'amount'),
              categoryId: any(named: 'categoryId'),
              month: any(named: 'month'),
            )).thenAnswer(
          (_) async =>
              [budgetJson(id: 10, categoryId: 5, amount: 2000, month: 3)],
        );

        final result = await repo.updateBudget(
          budgetId: 10,
          amount: 2000,
        );

        expect(result.id, 10);
        expect(result.amount, 2000);

        verify(() => mockRemote.updateBudget(
              budgetId: 10,
              amount: 2000,
              categoryId: null,
              month: null,
            )).called(1);
      });

      test('throws exception when remote returns empty response', () async {
        when(() => mockRemote.updateBudget(
              budgetId: any(named: 'budgetId'),
              amount: any(named: 'amount'),
              categoryId: any(named: 'categoryId'),
              month: any(named: 'month'),
            )).thenAnswer((_) async => []);

        expect(
          () => repo.updateBudget(budgetId: 1, amount: 100),
          throwsA(isA<Exception>()),
        );
      });

      test('throws exception when remote throws', () async {
        when(() => mockRemote.updateBudget(
              budgetId: any(named: 'budgetId'),
              amount: any(named: 'amount'),
              categoryId: any(named: 'categoryId'),
              month: any(named: 'month'),
            )).thenThrow(Exception('Update failed'));

        expect(
          () => repo.updateBudget(budgetId: 1, amount: 100),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('deleteBudget', () {
      test('deletes budget successfully', () async {
        when(() => mockRemote.deleteBudget(budgetId: any(named: 'budgetId')))
            .thenAnswer((_) async => []);

        await repo.deleteBudget(budgetId: 5);

        verify(() => mockRemote.deleteBudget(budgetId: 5)).called(1);
      });

      test('throws exception when remote throws', () async {
        when(() => mockRemote.deleteBudget(budgetId: any(named: 'budgetId')))
            .thenThrow(Exception('Delete failed'));

        expect(
          () => repo.deleteBudget(budgetId: 1),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('hasAnyBudget', () {
      test('returns true when budgets exist', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => 'user-1');

        when(() => mockRemote.getMyBudgets(uid: 'user-1'))
            .thenAnswer((_) async => [budgetJson()]);

        final result = await repo.hasAnyBudget();

        expect(result, true);
      });

      test('returns false when no budgets', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => 'user-1');

        when(() => mockRemote.getMyBudgets(uid: 'user-1'))
            .thenAnswer((_) async => []);

        final result = await repo.hasAnyBudget();

        expect(result, false);
      });
    });
  });
}
