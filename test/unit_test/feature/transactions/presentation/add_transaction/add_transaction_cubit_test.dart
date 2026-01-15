import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/usecases/add_transaction.dart';
import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';

import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/cubit/add_transaction_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/cubit/add_transaction_state.dart';

class MockAddTransaction extends Mock implements AddTransaction {}
class MockUserIdLocalDataSource extends Mock implements UserIdLocalDataSource {}

void main() {
  late MockAddTransaction addTx;
  late MockUserIdLocalDataSource userIdLocal;

  const incomeCat = CategoryEntity(
    id: 1,
    name: 'Salary',
    type: TransactionType.income,
    icon: 'salary',
  );

  const expenseCat = CategoryEntity(
    id: 2,
    name: 'Food',
    type: TransactionType.expense,
    icon: 'food',
  );

  setUpAll(() {
    registerFallbackValue(
      TransactionEntity(
        userId: 'u1',
        categoryId: 1,
        type: TransactionType.expense,
        amount: 10,
        date: DateTime(2025, 1, 1),
        note: null,
      ),
    );
  });

  setUp(() {
    addTx = MockAddTransaction();
    userIdLocal = MockUserIdLocalDataSource();
  });

  AddTransactionCubit buildCubit() => AddTransactionCubit(
        addTransaction: addTx,
        userIdLocal: userIdLocal,
      );

  group('AddTransactionCubit - setters', () {
    blocTest<AddTransactionCubit, AddTransactionState>(
      'setCategory infers type from category',
      build: buildCubit,
      act: (c) => c.setCategory(incomeCat),
      expect: () => [
        AddTransactionState.initial().copyWith(
          category: incomeCat,
          type: TransactionType.income,
          clearError: true,
        ),
      ],
    );

    blocTest<AddTransactionCubit, AddTransactionState>(
      'setDate normalizes to yyyy-mm-dd (no time)',
      build: buildCubit,
      act: (c) => c.setDate(DateTime(2025, 12, 31, 23, 59, 59)),
      expect: () => [
        AddTransactionState.initial().copyWith(
          date: DateTime(2025, 12, 31),
          clearError: true,
        ),
      ],
    );

    blocTest<AddTransactionCubit, AddTransactionState>(
      'clearCategory clears category',
      build: buildCubit,
      seed: () => AddTransactionState.initial().copyWith(category: expenseCat),
      act: (c) => c.clearCategory(),
      expect: () => [
        AddTransactionState.initial().copyWith(
          clearCategory: true,
          clearError: true,
        ),
      ],
    );
  });

  group('AddTransactionCubit - submit validations', () {
    blocTest<AddTransactionCubit, AddTransactionState>(
      'submit returns false & emits error when amount <= 0',
      build: buildCubit,
      seed: () => AddTransactionState.initial().copyWith(category: expenseCat),
      act: (c) => c.submit(),
      expect: () => [
        AddTransactionState.initial()
            .copyWith(category: expenseCat)
            .copyWith(error: 'Amount must be greater than 0.'),
      ],
      verify: (_) {
        verifyNever(() => userIdLocal.getUserId());
        verifyNever(() => addTx(any()));
      },
    );

    blocTest<AddTransactionCubit, AddTransactionState>(
      'submit returns false & emits error when category is missing',
      build: buildCubit,
      seed: () => AddTransactionState.initial().copyWith(amount: 100),
      act: (c) => c.submit(),
      expect: () => [
        AddTransactionState.initial()
            .copyWith(amount: 100)
            .copyWith(error: 'Please select a category.'),
      ],
      verify: (_) {
        verifyNever(() => userIdLocal.getUserId());
        verifyNever(() => addTx(any()));
      },
    );

    blocTest<AddTransactionCubit, AddTransactionState>(
      'submit returns false & emits error when userId is null/empty',
      build: buildCubit,
      setUp: () {
        when(() => userIdLocal.getUserId()).thenAnswer((_) async => '   ');
      },
      seed: () => AddTransactionState.initial().copyWith(
        category: expenseCat,
        amount: 50,
        date: DateTime(2025, 1, 2),
        note: 'note',
      ),
      act: (c) => c.submit(),
      expect: () => [
        // loading true
        AddTransactionState.initial().copyWith(
          category: expenseCat,
          amount: 50,
          date: DateTime(2025, 1, 2),
          note: 'note',
          isLoading: true,
          clearError: true,
          type: TransactionType.expense,
        ),
        // then fail with missing session
        AddTransactionState.initial().copyWith(
          category: expenseCat,
          amount: 50,
          date: DateTime(2025, 1, 2),
          note: 'note',
          isLoading: false,
          error: 'Missing user session. Please login again.',
          type: TransactionType.expense,
        ),
      ],
      verify: (_) {
        verify(() => userIdLocal.getUserId()).called(1);
        verifyNever(() => addTx(any()));
      },
    );
  });

  group('AddTransactionCubit - submit success/failure', () {
    blocTest<AddTransactionCubit, AddTransactionState>(
      'submit success: calls usecase with correct TransactionEntity, then resets state & returns true',
      build: buildCubit,
      setUp: () {
        when(() => userIdLocal.getUserId()).thenAnswer((_) async => 'user_1');
        when(() => addTx(any())).thenAnswer((_) async {});
      },
      seed: () => AddTransactionState.initial().copyWith(
        category: incomeCat, // type should follow category.type
        amount: 999,
        date: DateTime(2025, 6, 1),
        note: '  hello  ', // should trim
      ),
      act: (c) async {
        final ok = await c.submit();
        expect(ok, isTrue);
      },
      expect: () => [
        // isLoading true
        AddTransactionState.initial().copyWith(
          category: incomeCat,
          type: TransactionType.income,
          amount: 999,
          date: DateTime(2025, 6, 1),
          note: '  hello  ',
          isLoading: true,
          clearError: true,
        ),
        // reset to initial on success
        AddTransactionState.initial(),
      ],
      verify: (_) {
        final captured = verify(() => addTx(captureAny())).captured.single as TransactionEntity;

        expect(captured.userId, 'user_1');
        expect(captured.categoryId, incomeCat.id);
        expect(captured.type, incomeCat.type);
        expect(captured.amount, 999);
        expect(captured.date, DateTime(2025, 6, 1));
        expect(captured.note, 'hello'); // trimmed

        verify(() => userIdLocal.getUserId()).called(1);
        verifyNoMoreInteractions(userIdLocal);
      },
    );

    blocTest<AddTransactionCubit, AddTransactionState>(
      'submit failure: when usecase throws, emits isLoading=false & error not empty, returns false',
      build: buildCubit,
      setUp: () {
        when(() => userIdLocal.getUserId()).thenAnswer((_) async => 'user_1');
        when(() => addTx(any())).thenThrow(Exception('boom'));
      },
      seed: () => AddTransactionState.initial().copyWith(
        category: expenseCat,
        amount: 10,
        date: DateTime(2025, 6, 1),
      ),
      act: (c) async {
        final ok = await c.submit();
        expect(ok, isFalse);
      },
      expect: () => [
        AddTransactionState.initial().copyWith(
          category: expenseCat,
          type: TransactionType.expense,
          amount: 10,
          date: DateTime(2025, 6, 1),
          isLoading: true,
          clearError: true,
        ),
        predicate<AddTransactionState>((s) {
          return s.isLoading == false && (s.error?.isNotEmpty ?? false);
        }),
      ],
      verify: (_) {
        verify(() => userIdLocal.getUserId()).called(1);
        verify(() => addTx(any())).called(1);
      },
    );
  });
}
