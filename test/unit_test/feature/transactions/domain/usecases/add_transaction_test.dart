import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/repositories/transactions_repository.dart';
import 'package:finance_tracker_app/feature/transactions/domain/usecases/add_transaction.dart';

class MockTransactionsRepository extends Mock implements TransactionsRepository {}

void main() {
  late MockTransactionsRepository repo;
  late AddTransaction usecase;

  setUpAll(() {
    // For mocktail "any<TransactionEntity>()"
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
    repo = MockTransactionsRepository();
    usecase = AddTransaction(repo);
  });

  group('AddTransaction usecase', () {
    test('calls repo.addTransaction when tx is valid', () async {
      when(() => repo.addTransaction(any())).thenAnswer((_) async {});

      final tx = TransactionEntity(
        userId: 'user_123',
        categoryId: 10,
        type: TransactionType.income,
        amount: 123.45,
        date: DateTime(2025, 12, 31),
        note: 'hello',
      );

      await usecase(tx);

      verify(() => repo.addTransaction(tx)).called(1);
      verifyNoMoreInteractions(repo);
    });

    test('throws ValidationException when userId is empty', () async {
      final tx = TransactionEntity(
        userId: '   ',
        categoryId: 10,
        type: TransactionType.expense,
        amount: 10,
        date: DateTime(2025, 1, 1),
        note: null,
      );

      expect(
        () => usecase(tx),
        throwsA(isA<ValidationException>()),
      );

      verifyNever(() => repo.addTransaction(any()));
    });

    test('throws ValidationException when categoryId <= 0', () async {
      final tx = TransactionEntity(
        userId: 'u1',
        categoryId: 0,
        type: TransactionType.expense,
        amount: 10,
        date: DateTime(2025, 1, 1),
        note: null,
      );

      expect(
        () => usecase(tx),
        throwsA(isA<ValidationException>()),
      );

      verifyNever(() => repo.addTransaction(any()));
    });

    test('throws ValidationException when amount <= 0', () async {
      final tx = TransactionEntity(
        userId: 'u1',
        categoryId: 1,
        type: TransactionType.expense,
        amount: 0,
        date: DateTime(2025, 1, 1),
        note: null,
      );

      expect(
        () => usecase(tx),
        throwsA(isA<ValidationException>()),
      );

      verifyNever(() => repo.addTransaction(any()));
    });

    test('throws ValidationException when date.year < 2000', () async {
      final tx = TransactionEntity(
        userId: 'u1',
        categoryId: 1,
        type: TransactionType.expense,
        amount: 10,
        date: DateTime(1999, 12, 31),
        note: null,
      );

      expect(
        () => usecase(tx),
        throwsA(isA<ValidationException>()),
      );

      verifyNever(() => repo.addTransaction(any()));
    });

    test('throws ValidationException when note length > 300', () async {
      final longNote = List.filled(301, 'a').join();

      final tx = TransactionEntity(
        userId: 'u1',
        categoryId: 1,
        type: TransactionType.expense,
        amount: 10,
        date: DateTime(2025, 1, 1),
        note: longNote,
      );

      expect(
        () => usecase(tx),
        throwsA(isA<ValidationException>()),
      );

      verifyNever(() => repo.addTransaction(any()));
    });
  });
}
