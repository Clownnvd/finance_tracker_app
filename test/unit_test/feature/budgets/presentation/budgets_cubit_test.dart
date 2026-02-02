import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/budgets/domain/entities/budget.dart';
import 'package:finance_tracker_app/feature/budgets/domain/usecases/get_budgets.dart';
import 'package:finance_tracker_app/feature/budgets/domain/usecases/create_budget.dart';
import 'package:finance_tracker_app/feature/budgets/domain/usecases/update_budget.dart';
import 'package:finance_tracker_app/feature/budgets/domain/usecases/delete_budget.dart';
import 'package:finance_tracker_app/feature/budgets/presentation/cubit/budgets_cubit.dart';
import 'package:finance_tracker_app/feature/budgets/presentation/cubit/budgets_state.dart';

class MockGetBudgets extends Mock implements GetBudgets {}

class MockCreateBudget extends Mock implements CreateBudget {}

class MockUpdateBudget extends Mock implements UpdateBudget {}

class MockDeleteBudget extends Mock implements DeleteBudget {}

void main() {
  late MockGetBudgets mockGetBudgets;
  late MockCreateBudget mockCreateBudget;
  late MockUpdateBudget mockUpdateBudget;
  late MockDeleteBudget mockDeleteBudget;
  late BudgetsCubit cubit;

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

  setUp(() {
    mockGetBudgets = MockGetBudgets();
    mockCreateBudget = MockCreateBudget();
    mockUpdateBudget = MockUpdateBudget();
    mockDeleteBudget = MockDeleteBudget();

    cubit = BudgetsCubit(
      getBudgets: mockGetBudgets,
      createBudget: mockCreateBudget,
      updateBudget: mockUpdateBudget,
      deleteBudget: mockDeleteBudget,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('BudgetsCubit', () {
    group('load', () {
      blocTest<BudgetsCubit, BudgetsState>(
        'emits [isLoading=true, isLoading=false with budgets] on success',
        build: () {
          final budgets = [
            testBudget(id: 1, categoryId: 1, amount: 1000, month: 1),
            testBudget(id: 2, categoryId: 2, amount: 2000, month: 2),
          ];
          when(() => mockGetBudgets()).thenAnswer((_) async => budgets);
          return cubit;
        },
        act: (c) => c.load(),
        expect: () => [
          isA<BudgetsState>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<BudgetsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.budgets.length, 'budgets.length', 2)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
        ],
        verify: (_) {
          verify(() => mockGetBudgets()).called(1);
        },
      );

      blocTest<BudgetsCubit, BudgetsState>(
        'emits [isLoading=true, isLoading=false with error] on failure',
        build: () {
          when(() => mockGetBudgets()).thenThrow(Exception('Network error'));
          return cubit;
        },
        act: (c) => c.load(),
        expect: () => [
          isA<BudgetsState>()
              .having((s) => s.isLoading, 'isLoading', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<BudgetsState>()
              .having((s) => s.isLoading, 'isLoading', false)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('refresh', () {
      blocTest<BudgetsCubit, BudgetsState>(
        'calls load() internally',
        build: () {
          when(() => mockGetBudgets()).thenAnswer((_) async => []);
          return cubit;
        },
        act: (c) => c.refresh(),
        verify: (_) {
          verify(() => mockGetBudgets()).called(1);
        },
      );
    });

    group('createOrUpdate', () {
      blocTest<BudgetsCubit, BudgetsState>(
        'creates new budget when no existing budget for category+month',
        build: () {
          final newBudget = testBudget(id: 1, categoryId: 5, amount: 500, month: 3);
          when(() => mockGetBudgets()).thenAnswer((_) async => []);
          when(() => mockCreateBudget(
                categoryId: any(named: 'categoryId'),
                amount: any(named: 'amount'),
                month: any(named: 'month'),
              )).thenAnswer((_) async => newBudget);
          return cubit;
        },
        act: (c) => c.createOrUpdate(categoryId: 5, amount: 500, month: 3),
        expect: () => [
          isA<BudgetsState>()
              .having((s) => s.isSaving, 'isSaving', true)
              .having((s) => s.lastCreatedOrUpdated, 'lastCreatedOrUpdated', isNull),
          isA<BudgetsState>()
              .having((s) => s.isSaving, 'isSaving', false)
              .having((s) => s.budgets.length, 'budgets.length', 1)
              .having((s) => s.lastCreatedOrUpdated, 'lastCreatedOrUpdated', isNotNull)
              .having((s) => s.lastCreatedOrUpdated?.categoryId, 'categoryId', 5),
        ],
        verify: (_) {
          verify(() => mockCreateBudget(categoryId: 5, amount: 500, month: 3)).called(1);
          verifyNever(() => mockUpdateBudget(
                budgetId: any(named: 'budgetId'),
                amount: any(named: 'amount'),
                categoryId: any(named: 'categoryId'),
                month: any(named: 'month'),
              ));
        },
      );

      blocTest<BudgetsCubit, BudgetsState>(
        'updates existing budget when budget exists for category+month',
        build: () {
          final existingBudget = testBudget(id: 10, categoryId: 5, amount: 500, month: 3);
          final updatedBudget = testBudget(id: 10, categoryId: 5, amount: 800, month: 3);

          when(() => mockUpdateBudget(
                budgetId: any(named: 'budgetId'),
                amount: any(named: 'amount'),
                categoryId: any(named: 'categoryId'),
                month: any(named: 'month'),
              )).thenAnswer((_) async => updatedBudget);

          return cubit;
        },
        seed: () => BudgetsState.initial().copyWith(
          isLoading: false,
          budgets: [testBudget(id: 10, categoryId: 5, amount: 500, month: 3)],
        ),
        act: (c) => c.createOrUpdate(categoryId: 5, amount: 800, month: 3),
        expect: () => [
          isA<BudgetsState>()
              .having((s) => s.isSaving, 'isSaving', true)
              .having((s) => s.lastCreatedOrUpdated, 'lastCreatedOrUpdated', isNull),
          isA<BudgetsState>()
              .having((s) => s.isSaving, 'isSaving', false)
              .having((s) => s.budgets.length, 'budgets.length', 1)
              .having((s) => s.budgets.first.amount, 'amount', 800)
              .having((s) => s.lastCreatedOrUpdated, 'lastCreatedOrUpdated', isNotNull),
        ],
        verify: (_) {
          verify(() => mockUpdateBudget(
                budgetId: 10,
                amount: 800,
                categoryId: 5,
                month: 3,
              )).called(1);
          verifyNever(() => mockCreateBudget(
                categoryId: any(named: 'categoryId'),
                amount: any(named: 'amount'),
                month: any(named: 'month'),
              ));
        },
      );

      blocTest<BudgetsCubit, BudgetsState>(
        'fetches budgets first if state.budgets is empty before checking',
        build: () {
          final existingBudget = testBudget(id: 10, categoryId: 5, amount: 500, month: 3);
          final updatedBudget = testBudget(id: 10, categoryId: 5, amount: 800, month: 3);

          when(() => mockGetBudgets()).thenAnswer((_) async => [existingBudget]);
          when(() => mockUpdateBudget(
                budgetId: any(named: 'budgetId'),
                amount: any(named: 'amount'),
                categoryId: any(named: 'categoryId'),
                month: any(named: 'month'),
              )).thenAnswer((_) async => updatedBudget);

          return cubit;
        },
        seed: () => BudgetsState.initial().copyWith(isLoading: false, budgets: []),
        act: (c) => c.createOrUpdate(categoryId: 5, amount: 800, month: 3),
        verify: (_) {
          verify(() => mockGetBudgets()).called(1);
          verify(() => mockUpdateBudget(
                budgetId: 10,
                amount: 800,
                categoryId: 5,
                month: 3,
              )).called(1);
        },
      );

      blocTest<BudgetsCubit, BudgetsState>(
        'emits error on failure',
        build: () {
          when(() => mockGetBudgets()).thenAnswer((_) async => []);
          when(() => mockCreateBudget(
                categoryId: any(named: 'categoryId'),
                amount: any(named: 'amount'),
                month: any(named: 'month'),
              )).thenThrow(Exception('Create failed'));
          return cubit;
        },
        act: (c) => c.createOrUpdate(categoryId: 1, amount: 100, month: 1),
        expect: () => [
          isA<BudgetsState>()
              .having((s) => s.isSaving, 'isSaving', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<BudgetsState>()
              .having((s) => s.isSaving, 'isSaving', false)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('update', () {
      blocTest<BudgetsCubit, BudgetsState>(
        'updates budget and emits new state with updated list',
        build: () {
          final updatedBudget = testBudget(id: 1, categoryId: 1, amount: 2000, month: 1);
          when(() => mockUpdateBudget(
                budgetId: any(named: 'budgetId'),
                amount: any(named: 'amount'),
                categoryId: any(named: 'categoryId'),
                month: any(named: 'month'),
              )).thenAnswer((_) async => updatedBudget);
          return cubit;
        },
        seed: () => BudgetsState.initial().copyWith(
          isLoading: false,
          budgets: [testBudget(id: 1, categoryId: 1, amount: 1000, month: 1)],
        ),
        act: (c) => c.update(budgetId: 1, amount: 2000),
        expect: () => [
          isA<BudgetsState>()
              .having((s) => s.isSaving, 'isSaving', true)
              .having((s) => s.lastCreatedOrUpdated, 'lastCreatedOrUpdated', isNull),
          isA<BudgetsState>()
              .having((s) => s.isSaving, 'isSaving', false)
              .having((s) => s.budgets.first.amount, 'amount', 2000)
              .having((s) => s.lastCreatedOrUpdated, 'lastCreatedOrUpdated', isNotNull),
        ],
        verify: (_) {
          verify(() => mockUpdateBudget(
                budgetId: 1,
                amount: 2000,
                categoryId: null,
                month: null,
              )).called(1);
        },
      );

      blocTest<BudgetsCubit, BudgetsState>(
        'emits error on failure',
        build: () {
          when(() => mockUpdateBudget(
                budgetId: any(named: 'budgetId'),
                amount: any(named: 'amount'),
                categoryId: any(named: 'categoryId'),
                month: any(named: 'month'),
              )).thenThrow(Exception('Update failed'));
          return cubit;
        },
        seed: () => BudgetsState.initial().copyWith(
          isLoading: false,
          budgets: [testBudget(id: 1)],
        ),
        act: (c) => c.update(budgetId: 1, amount: 2000),
        expect: () => [
          isA<BudgetsState>()
              .having((s) => s.isSaving, 'isSaving', true)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<BudgetsState>()
              .having((s) => s.isSaving, 'isSaving', false)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('delete', () {
      blocTest<BudgetsCubit, BudgetsState>(
        'deletes budget and removes from list',
        build: () {
          when(() => mockDeleteBudget(budgetId: any(named: 'budgetId')))
              .thenAnswer((_) async {});
          return cubit;
        },
        seed: () => BudgetsState.initial().copyWith(
          isLoading: false,
          budgets: [
            testBudget(id: 1, month: 1),
            testBudget(id: 2, month: 2),
          ],
        ),
        act: (c) => c.delete(budgetId: 1),
        expect: () => [
          isA<BudgetsState>()
              .having((s) => s.deletingBudgetId, 'deletingBudgetId', 1)
              .having((s) => s.budgets.length, 'budgets.length', 2),
          isA<BudgetsState>()
              .having((s) => s.deletingBudgetId, 'deletingBudgetId', isNull)
              .having((s) => s.budgets.length, 'budgets.length', 1)
              .having((s) => s.budgets.first.id, 'remaining id', 2),
        ],
        verify: (_) {
          verify(() => mockDeleteBudget(budgetId: 1)).called(1);
        },
      );

      blocTest<BudgetsCubit, BudgetsState>(
        'emits error on failure and keeps budgets',
        build: () {
          when(() => mockDeleteBudget(budgetId: any(named: 'budgetId')))
              .thenThrow(Exception('Delete failed'));
          return cubit;
        },
        seed: () => BudgetsState.initial().copyWith(
          isLoading: false,
          budgets: [testBudget(id: 1)],
        ),
        act: (c) => c.delete(budgetId: 1),
        expect: () => [
          isA<BudgetsState>()
              .having((s) => s.deletingBudgetId, 'deletingBudgetId', 1)
              .having((s) => s.errorMessage, 'errorMessage', isNull),
          isA<BudgetsState>()
              .having((s) => s.deletingBudgetId, 'deletingBudgetId', isNull)
              .having((s) => s.budgets.length, 'budgets.length', 1)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('clearLastSaved', () {
      blocTest<BudgetsCubit, BudgetsState>(
        'clears lastCreatedOrUpdated when not null',
        build: () => cubit,
        seed: () => BudgetsState.initial().copyWith(
          lastCreatedOrUpdated: testBudget(id: 1),
        ),
        act: (c) => c.clearLastSaved(),
        expect: () => [
          isA<BudgetsState>()
              .having((s) => s.lastCreatedOrUpdated, 'lastCreatedOrUpdated', isNull),
        ],
      );

      blocTest<BudgetsCubit, BudgetsState>(
        'does nothing when lastCreatedOrUpdated is already null',
        build: () => cubit,
        seed: () => BudgetsState.initial().copyWith(lastCreatedOrUpdated: null),
        act: (c) => c.clearLastSaved(),
        expect: () => <BudgetsState>[],
      );
    });
  });
}
