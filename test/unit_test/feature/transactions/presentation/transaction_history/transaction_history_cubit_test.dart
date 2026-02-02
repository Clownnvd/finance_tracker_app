import 'package:bloc_test/bloc_test.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/repositories/transactions_repository.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/cubit/transaction_history_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/cubit/transaction_history_state.dart';

class MockTransactionsRepository extends Mock implements TransactionsRepository {}

void main() {
  late MockTransactionsRepository repo;
  late TransactionHistoryCubit cubit;

  TransactionEntity tx({
    int? id,
    required TransactionType type,
    required double amount,
    required DateTime date,
  }) {
    return TransactionEntity(
      id: id,
      userId: 'u1',
      categoryId: 1,
      type: type,
      amount: amount,
      date: date,
      note: null,
    );
  }

  setUpAll(() {
    registerFallbackValue(DateTime(2025, 1, 1));
  });

  setUp(() {
    repo = MockTransactionsRepository();
    cubit = TransactionHistoryCubit(repo: repo);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('TransactionHistoryCubit', () {
    blocTest<TransactionHistoryCubit, TransactionHistoryState>(
      'load success: resets list, fetch page 1, hasMore true when >= 20',
      build: () {
        final items = List.generate(
          20,
          (i) => tx(
            id: i,
            type: i.isEven ? TransactionType.income : TransactionType.expense,
            amount: 100 + i.toDouble(),
            date: DateTime(2025, 1, 30, 12, i),
          ),
        );

        when(() => repo.getTransactionHistory(
              from: any(named: 'from'),
              to: any(named: 'to'),
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((inv) async {
          final limit = inv.namedArguments[#limit] as int;
          final offset = inv.namedArguments[#offset] as int;
          expect(limit, 20);
          expect(offset, 0);
          return items;
        });

        return cubit;
      },
      act: (c) => c.load(from: DateTime(2025, 1, 1), to: DateTime(2025, 1, 31)),
      expect: () => [
        isA<TransactionHistoryState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false)
            .having((s) => s.hasMore, 'hasMore', true)
            .having((s) => s.items.length, 'items.length', 0)
            .having((s) => s.error, 'error', isNull),
        isA<TransactionHistoryState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false)
            .having((s) => s.items.length, 'items.length', 20)
            .having((s) => s.hasMore, 'hasMore', true)
            .having((s) => s.error, 'error', isNull),
      ],
      verify: (_) {
        verify(() => repo.getTransactionHistory(
              from: any(named: 'from'),
              to: any(named: 'to'),
              limit: 20,
              offset: 0,
              cancelToken: any(named: 'cancelToken'),
            )).called(1);
      },
    );

    blocTest<TransactionHistoryCubit, TransactionHistoryState>(
      'load success: hasMore false when < 20',
      build: () {
        final items = List.generate(
          5,
          (i) => tx(
            id: i,
            type: TransactionType.expense,
            amount: 10,
            date: DateTime(2025, 1, 1, 10, i),
          ),
        );

        when(() => repo.getTransactionHistory(
              from: any(named: 'from'),
              to: any(named: 'to'),
              limit: 20,
              offset: 0,
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => items);

        return cubit;
      },
      act: (c) => c.load(),
      expect: () => [
        isA<TransactionHistoryState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.items.length, 'items.length', 0)
            .having((s) => s.hasMore, 'hasMore', true)
            .having((s) => s.error, 'error', isNull),
        isA<TransactionHistoryState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.items.length, 'items.length', 5)
            .having((s) => s.hasMore, 'hasMore', false)
            .having((s) => s.error, 'error', isNull),
      ],
    );

    blocTest<TransactionHistoryCubit, TransactionHistoryState>(
      'load ignores when state.isLoading == true',
      build: () {
        when(() => repo.getTransactionHistory(
              from: any(named: 'from'),
              to: any(named: 'to'),
              limit: any(named: 'limit'),
              offset: any(named: 'offset'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => []);

        return cubit;
      },
      seed: () => TransactionHistoryState.initial().copyWith(isLoading: true),
      act: (c) => c.load(),
      expect: () => <TransactionHistoryState>[],
      verify: (_) => verifyNever(() => repo.getTransactionHistory(
            from: any(named: 'from'),
            to: any(named: 'to'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            cancelToken: any(named: 'cancelToken'),
          )),
    );

    blocTest<TransactionHistoryCubit, TransactionHistoryState>(
      'load error: emits error and isLoading=false (list cleared)',
      build: () {
        when(() => repo.getTransactionHistory(
              from: any(named: 'from'),
              to: any(named: 'to'),
              limit: 20,
              offset: 0,
              cancelToken: any(named: 'cancelToken'),
            )).thenThrow(Exception('boom'));
        return cubit;
      },
      act: (c) => c.load(),
      expect: () => [
        isA<TransactionHistoryState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.items.length, 'items.length', 0)
            .having((s) => s.hasMore, 'hasMore', true)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false)
            .having((s) => s.error, 'error', isNull),
        isA<TransactionHistoryState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false)
            .having((s) => s.items.length, 'items.length', 0)
            .having((s) => s.hasMore, 'hasMore', true)
            .having((s) => s.error, 'error', isNotNull),
      ],
    );

    blocTest<TransactionHistoryCubit, TransactionHistoryState>(
      'loadMore does nothing when hasMore=false',
      build: () => cubit,
      seed: () => TransactionHistoryState.initial().copyWith(hasMore: false),
      act: (c) => c.loadMore(),
      expect: () => <TransactionHistoryState>[],
      verify: (_) => verifyNever(() => repo.getTransactionHistory(
            from: any(named: 'from'),
            to: any(named: 'to'),
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            cancelToken: any(named: 'cancelToken'),
          )),
    );

    blocTest<TransactionHistoryCubit, TransactionHistoryState>(
      'loadMore success: appends items and updates hasMore',
      build: () {
        when(() => repo.getTransactionHistory(
              from: any(named: 'from'),
              to: any(named: 'to'),
              limit: 20,
              offset: 2,
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async {
          return [
            tx(
              id: 3,
              type: TransactionType.income,
              amount: 100,
              date: DateTime(2025, 1, 1, 12, 3),
            ),
          ];
        });
        return cubit;
      },
      seed: () => TransactionHistoryState.initial().copyWith(
        items: [
          tx(
            id: 1,
            type: TransactionType.expense,
            amount: 10,
            date: DateTime(2025, 1, 1, 12, 1),
          ),
          tx(
            id: 2,
            type: TransactionType.expense,
            amount: 20,
            date: DateTime(2025, 1, 1, 12, 2),
          ),
        ],
        hasMore: true,
      ),
      act: (c) => c.loadMore(),
      expect: () => [
        isA<TransactionHistoryState>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', true)
            .having((s) => s.hasMore, 'hasMore', true)
            .having((s) => s.error, 'error', isNull)
            .having((s) => s.items.length, 'items.length', 2),
        isA<TransactionHistoryState>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', false)
            .having((s) => s.hasMore, 'hasMore', false)
            .having((s) => s.error, 'error', isNull)
            .having((s) => s.items.length, 'items.length', 3),
      ],
      verify: (_) => verify(() => repo.getTransactionHistory(
            from: any(named: 'from'),
            to: any(named: 'to'),
            limit: 20,
            offset: 2,
            cancelToken: any(named: 'cancelToken'),
          )).called(1),
    );

    blocTest<TransactionHistoryCubit, TransactionHistoryState>(
      'loadMore error: emits error and isLoadingMore=false (keeps existing items)',
      build: () {
        when(() => repo.getTransactionHistory(
              from: any(named: 'from'),
              to: any(named: 'to'),
              limit: 20,
              offset: 1,
              cancelToken: any(named: 'cancelToken'),
            )).thenThrow(Exception('boom'));
        return cubit;
      },
      seed: () => TransactionHistoryState.initial().copyWith(
        items: [
          tx(
            id: 1,
            type: TransactionType.expense,
            amount: 10,
            date: DateTime(2025, 1, 1, 10),
          )
        ],
        hasMore: true,
      ),
      act: (c) => c.loadMore(),
      expect: () => [
        isA<TransactionHistoryState>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', true)
            .having((s) => s.items.length, 'items.length', 1)
            .having((s) => s.error, 'error', isNull),
        isA<TransactionHistoryState>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', false)
            .having((s) => s.items.length, 'items.length', 1)
            .having((s) => s.error, 'error', isNotNull),
      ],
    );
  });
}
