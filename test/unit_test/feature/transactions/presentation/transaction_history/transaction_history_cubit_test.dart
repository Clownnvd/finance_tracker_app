import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
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
        TransactionHistoryState.initial().copyWith(
          isLoading: true,
          error: null,
          items: <TransactionEntity>[],
          hasMore: true,
          isLoadingMore: false,
        ),
        predicate<TransactionHistoryState>((s) {
          return s.isLoading == false &&
              s.items.length == 20 &&
              s.hasMore == true &&
              s.isLoadingMore == false &&
              s.error == null;
        }),
      ],
      verify: (_) {
        verify(() => repo.getTransactionHistory(
              from: any(named: 'from'),
              to: any(named: 'to'),
              limit: 20,
              offset: 0,
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
            )).thenAnswer((_) async => items);

        return cubit;
      },
      act: (c) => c.load(),
      expect: () => [
        TransactionHistoryState.initial().copyWith(
          isLoading: true,
          error: null,
          items: <TransactionEntity>[],
          hasMore: true,
          isLoadingMore: false,
        ),
        TransactionHistoryState.initial().copyWith(
          isLoading: false,
          items: List.generate(
            5,
            (i) => tx(
              id: i,
              type: TransactionType.expense,
              amount: 10,
              date: DateTime(2025, 1, 1, 10, i),
            ),
          ),
          hasMore: false,
        ),
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
          )),
    );

    blocTest<TransactionHistoryCubit, TransactionHistoryState>(
      'load error: emits error and isLoading=false',
      build: () {
        when(() => repo.getTransactionHistory(
              from: any(named: 'from'),
              to: any(named: 'to'),
              limit: 20,
              offset: 0,
            )).thenThrow(Exception('boom'));
        return cubit;
      },
      act: (c) => c.load(),
      expect: () => [
        TransactionHistoryState.initial().copyWith(
          isLoading: true,
          error: null,
          items: <TransactionEntity>[],
          hasMore: true,
          isLoadingMore: false,
        ),
        predicate<TransactionHistoryState>((s) =>
            s.isLoading == false && (s.error?.isNotEmpty ?? false)),
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
            )).thenAnswer((_) async {
          // return < 20 => hasMore false
          return [
            tx(id: 3, type: TransactionType.income, amount: 100, date: DateTime(2025, 1, 1, 12, 3)),
          ];
        });
        return cubit;
      },
      seed: () => TransactionHistoryState.initial().copyWith(
        items: [
          tx(id: 1, type: TransactionType.expense, amount: 10, date: DateTime(2025, 1, 1, 12, 1)),
          tx(id: 2, type: TransactionType.expense, amount: 20, date: DateTime(2025, 1, 1, 12, 2)),
        ],
        hasMore: true,
      ),
      act: (c) => c.loadMore(),
      expect: () => [
        TransactionHistoryState.initial().copyWith(
          items: [
            tx(id: 1, type: TransactionType.expense, amount: 10, date: DateTime(2025, 1, 1, 12, 1)),
            tx(id: 2, type: TransactionType.expense, amount: 20, date: DateTime(2025, 1, 1, 12, 2)),
          ],
          hasMore: true,
          isLoadingMore: true,
          error: null,
        ),
        TransactionHistoryState.initial().copyWith(
          items: [
            tx(id: 1, type: TransactionType.expense, amount: 10, date: DateTime(2025, 1, 1, 12, 1)),
            tx(id: 2, type: TransactionType.expense, amount: 20, date: DateTime(2025, 1, 1, 12, 2)),
            tx(id: 3, type: TransactionType.income, amount: 100, date: DateTime(2025, 1, 1, 12, 3)),
          ],
          isLoadingMore: false,
          hasMore: false,
        ),
      ],
      verify: (_) => verify(() => repo.getTransactionHistory(
            from: any(named: 'from'),
            to: any(named: 'to'),
            limit: 20,
            offset: 2,
          )).called(1),
    );

    blocTest<TransactionHistoryCubit, TransactionHistoryState>(
      'loadMore error: emits error and isLoadingMore=false',
      build: () {
        when(() => repo.getTransactionHistory(
              from: any(named: 'from'),
              to: any(named: 'to'),
              limit: 20,
              offset: 1,
            )).thenThrow(Exception('boom'));
        return cubit;
      },
      seed: () => TransactionHistoryState.initial().copyWith(
        items: [tx(id: 1, type: TransactionType.expense, amount: 10, date: DateTime(2025, 1, 1, 10))],
        hasMore: true,
      ),
      act: (c) => c.loadMore(),
      expect: () => [
        TransactionHistoryState.initial().copyWith(
          items: [tx(id: 1, type: TransactionType.expense, amount: 10, date: DateTime(2025, 1, 1, 10))],
          hasMore: true,
          isLoadingMore: true,
          error: null,
        ),
        predicate<TransactionHistoryState>((s) =>
            s.isLoadingMore == false && (s.error?.isNotEmpty ?? false)),
      ],
    );
  });
}
