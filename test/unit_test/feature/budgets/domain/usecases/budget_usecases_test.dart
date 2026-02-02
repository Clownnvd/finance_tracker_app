import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/budgets/domain/entities/budget.dart';
import 'package:finance_tracker_app/feature/budgets/domain/repositories/budgets_repository.dart';
import 'package:finance_tracker_app/feature/budgets/domain/usecases/get_budgets.dart';
import 'package:finance_tracker_app/feature/budgets/domain/usecases/create_budget.dart';
import 'package:finance_tracker_app/feature/budgets/domain/usecases/update_budget.dart';
import 'package:finance_tracker_app/feature/budgets/domain/usecases/delete_budget.dart';
import 'package:finance_tracker_app/feature/budgets/domain/usecases/has_any_budget.dart';

class MockBudgetsRepository extends Mock implements BudgetsRepository {}

void main() {
  late MockBudgetsRepository mockRepo;

  setUp(() {
    mockRepo = MockBudgetsRepository();
  });

  Budget testBudget({
    int id = 1,
    String userId = 'user-1',
    int categoryId = 1,
    double amount = 1000,
    int month = 1,
  }) {
    return Budget(
      id: id,
      userId: userId,
      categoryId: categoryId,
      amount: amount,
      month: month,
    );
  }

  group('GetBudgets', () {
    late GetBudgets usecase;

    setUp(() {
      usecase = GetBudgets(mockRepo);
    });

    test('calls repo.getMyBudgets and returns result', () async {
      final budgets = [
        testBudget(id: 1, month: 1),
        testBudget(id: 2, month: 2),
      ];
      when(() => mockRepo.getMyBudgets()).thenAnswer((_) async => budgets);

      final result = await usecase();

      expect(result, budgets);
      expect(result.length, 2);
      verify(() => mockRepo.getMyBudgets()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('throws when repo throws', () async {
      when(() => mockRepo.getMyBudgets()).thenThrow(Exception('Error'));

      expect(() => usecase(), throwsA(isA<Exception>()));
    });
  });

  group('CreateBudget', () {
    late CreateBudget usecase;

    setUp(() {
      usecase = CreateBudget(mockRepo);
    });

    test('calls repo.createBudget with correct params and returns result',
        () async {
      final budget = testBudget(id: 5, categoryId: 3, amount: 500, month: 6);
      when(() => mockRepo.createBudget(
            categoryId: any(named: 'categoryId'),
            amount: any(named: 'amount'),
            month: any(named: 'month'),
          )).thenAnswer((_) async => budget);

      final result = await usecase(categoryId: 3, amount: 500, month: 6);

      expect(result, budget);
      expect(result.categoryId, 3);
      expect(result.amount, 500);
      expect(result.month, 6);

      verify(() => mockRepo.createBudget(
            categoryId: 3,
            amount: 500,
            month: 6,
          )).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('throws when repo throws', () async {
      when(() => mockRepo.createBudget(
            categoryId: any(named: 'categoryId'),
            amount: any(named: 'amount'),
            month: any(named: 'month'),
          )).thenThrow(Exception('Create failed'));

      expect(
        () => usecase(categoryId: 1, amount: 100, month: 1),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('UpdateBudget', () {
    late UpdateBudget usecase;

    setUp(() {
      usecase = UpdateBudget(mockRepo);
    });

    test('calls repo.updateBudget with all params', () async {
      final budget = testBudget(id: 10, categoryId: 5, amount: 2000, month: 3);
      when(() => mockRepo.updateBudget(
            budgetId: any(named: 'budgetId'),
            amount: any(named: 'amount'),
            categoryId: any(named: 'categoryId'),
            month: any(named: 'month'),
          )).thenAnswer((_) async => budget);

      final result = await usecase(
        budgetId: 10,
        amount: 2000,
        categoryId: 5,
        month: 3,
      );

      expect(result, budget);
      verify(() => mockRepo.updateBudget(
            budgetId: 10,
            amount: 2000,
            categoryId: 5,
            month: 3,
          )).called(1);
    });

    test('calls repo.updateBudget with partial params', () async {
      final budget = testBudget(id: 10, amount: 3000);
      when(() => mockRepo.updateBudget(
            budgetId: any(named: 'budgetId'),
            amount: any(named: 'amount'),
            categoryId: any(named: 'categoryId'),
            month: any(named: 'month'),
          )).thenAnswer((_) async => budget);

      final result = await usecase(budgetId: 10, amount: 3000);

      expect(result.amount, 3000);
      verify(() => mockRepo.updateBudget(
            budgetId: 10,
            amount: 3000,
            categoryId: null,
            month: null,
          )).called(1);
    });

    test('throws when repo throws', () async {
      when(() => mockRepo.updateBudget(
            budgetId: any(named: 'budgetId'),
            amount: any(named: 'amount'),
            categoryId: any(named: 'categoryId'),
            month: any(named: 'month'),
          )).thenThrow(Exception('Update failed'));

      expect(
        () => usecase(budgetId: 1, amount: 100),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('DeleteBudget', () {
    late DeleteBudget usecase;

    setUp(() {
      usecase = DeleteBudget(mockRepo);
    });

    test('calls repo.deleteBudget with correct budgetId', () async {
      when(() => mockRepo.deleteBudget(budgetId: any(named: 'budgetId')))
          .thenAnswer((_) async {});

      await usecase(budgetId: 5);

      verify(() => mockRepo.deleteBudget(budgetId: 5)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('throws when repo throws', () async {
      when(() => mockRepo.deleteBudget(budgetId: any(named: 'budgetId')))
          .thenThrow(Exception('Delete failed'));

      expect(
        () => usecase(budgetId: 1),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('HasAnyBudget', () {
    late HasAnyBudget usecase;

    setUp(() {
      usecase = HasAnyBudget(mockRepo);
    });

    test('returns true when repo.hasAnyBudget returns true', () async {
      when(() => mockRepo.hasAnyBudget()).thenAnswer((_) async => true);

      final result = await usecase();

      expect(result, true);
      verify(() => mockRepo.hasAnyBudget()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns false when repo.hasAnyBudget returns false', () async {
      when(() => mockRepo.hasAnyBudget()).thenAnswer((_) async => false);

      final result = await usecase();

      expect(result, false);
      verify(() => mockRepo.hasAnyBudget()).called(1);
    });

    test('throws when repo throws', () async {
      when(() => mockRepo.hasAnyBudget()).thenThrow(Exception('Error'));

      expect(() => usecase(), throwsA(isA<Exception>()));
    });
  });
}
