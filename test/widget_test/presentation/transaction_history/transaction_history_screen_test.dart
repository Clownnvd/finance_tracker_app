import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/di/di.dart';
import 'package:finance_tracker_app/core/constants/strings.dart';

import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/usecases/get_categories.dart';

import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/cubit/transaction_history_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/cubit/transaction_history_state.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/pages/transaction_history_screen.dart';

class MockTransactionHistoryCubit extends MockCubit<TransactionHistoryState>
    implements TransactionHistoryCubit {}

class MockGetCategories extends Mock implements GetCategories {}

class _FakeRoute extends Fake implements Route<dynamic> {}

Future<void> _stablePump(WidgetTester tester) async {
  // Flush microtasks + post-frame callbacks reliably.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
}

Future<void> _pumpFor(
  WidgetTester tester,
  Duration duration, {
  Duration step = const Duration(milliseconds: 50),
}) async {
  var elapsed = Duration.zero;
  while (elapsed < duration) {
    await tester.pump(step);
    elapsed += step;
  }
}

TransactionEntity _tx({
  int? id,
  required TransactionType type,
  required double amount,
  required DateTime date,
}) {
  return TransactionEntity(
    id: id,
    userId: 'u1',
    categoryId: type == TransactionType.income ? 10 : 1,
    type: type,
    amount: amount,
    date: date,
    note: null,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockTransactionHistoryCubit cubit;
  late MockGetCategories mockGetCategories;

  setUpAll(() {
    registerFallbackValue(_FakeRoute());
    registerFallbackValue(TransactionHistoryState.initial());
  });

  setUp(() async {
    cubit = MockTransactionHistoryCubit();
    mockGetCategories = MockGetCategories();

    // Reset DI between tests (must use the same getIt instance as the screen).
    if (getIt.isRegistered<GetCategories>()) {
      await getIt.unregister<GetCategories>();
    }
    getIt.registerSingleton<GetCategories>(mockGetCategories);

    // The screen calls these methods from initState / refresh / pagination paths.
    // If they are not stubbed, Mocktail returns null => TypeError (null is not Future<void>).
    when(() => cubit.load(from: any(named: 'from'), to: any(named: 'to')))
        .thenAnswer((_) async {});
    when(() => cubit.refresh(from: any(named: 'from'), to: any(named: 'to')))
        .thenAnswer((_) async {});
    when(() => cubit.loadMore(from: any(named: 'from'), to: any(named: 'to')))
        .thenAnswer((_) async {});
  });

  tearDown(() async {
    if (getIt.isRegistered<GetCategories>()) {
      await getIt.unregister<GetCategories>();
    }
  });

  Widget _buildApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<TransactionHistoryCubit>.value(
        value: cubit,
        child: const TransactionHistoryScreen(currencySymbol: '₫'),
      ),
    );
  }

  testWidgets(
    'on first frame: loads categories via GetIt, then calls cubit.load()',
    (tester) async {
      when(() => mockGetCategories.call()).thenAnswer((_) async => const [
            CategoryEntity(
              id: 1,
              name: 'Food',
              type: TransactionType.expense,
              icon: 'food',
            ),
            CategoryEntity(
              id: 10,
              name: 'Salary',
              type: TransactionType.income,
              icon: 'salary',
            ),
          ]);

      final initial = TransactionHistoryState.initial();
      when(() => cubit.state).thenReturn(initial);
      whenListen<TransactionHistoryState>(
        cubit,
        const Stream<TransactionHistoryState>.empty(),
        initialState: initial,
      );

      await tester.pumpWidget(_buildApp());

      // Post-frame: _loadCategories() awaits GetCategories.call(), then cubit.load().
      await _stablePump(tester);

      verify(() => mockGetCategories.call()).called(1);
      verify(() => cubit.load(from: any(named: 'from'), to: any(named: 'to')))
          .called(1);
    },
  );

  testWidgets(
    'when category load throws: shows top error banner with prefix',
    (tester) async {
      when(() => mockGetCategories.call()).thenThrow(Exception('cat boom'));

      final initial = TransactionHistoryState.initial();
      when(() => cubit.state).thenReturn(initial);
      whenListen<TransactionHistoryState>(
        cubit,
        const Stream<TransactionHistoryState>.empty(),
        initialState: initial,
      );

      await tester.pumpWidget(_buildApp());

      // Allow post-frame + setState for banner.
      await _stablePump(tester);
      await _pumpFor(tester, const Duration(milliseconds: 200));

      expect(
        find.textContaining(AppStrings.categoryLoadFailedPrefix),
        findsOneWidget,
      );
    },
  );

  testWidgets(
  'pull-to-refresh triggers cubit.refresh() (stable)',
  (tester) async {
    when(() => mockGetCategories.call()).thenAnswer((_) async => const [
          CategoryEntity(
            id: 1,
            name: 'Food',
            type: TransactionType.expense,
            icon: 'food',
          ),
        ]);

    final loaded = TransactionHistoryState.initial().copyWith(
      isLoading: false,
      items: [
        _tx(
          id: 1,
          type: TransactionType.expense,
          amount: 10,
          date: DateTime(2025, 1, 15, 10),
        ),
      ],
      hasMore: false,
    );

    when(() => cubit.state).thenReturn(loaded);
    whenListen<TransactionHistoryState>(
      cubit,
      Stream.fromIterable([loaded]),
      initialState: loaded,
    );

    await tester.pumpWidget(_buildApp());
    await _stablePump(tester);

    // Instead of relying on drag physics (flaky), call RefreshIndicator.onRefresh directly.
    final riFinder = find.byType(RefreshIndicator);
    expect(riFinder, findsOneWidget);

    final ri = tester.widget<RefreshIndicator>(riFinder);
    // onRefresh returns Future<void>
    await ri.onRefresh();
    await tester.pump();

    verify(() => cubit.refresh(from: any(named: 'from'), to: any(named: 'to')))
        .called(1);
  },
);


  testWidgets(
    'when state has items: renders Transaction History title',
    (tester) async {
      when(() => mockGetCategories.call()).thenAnswer((_) async => const [
            CategoryEntity(
              id: 1,
              name: 'Food',
              type: TransactionType.expense,
              icon: 'food',
            ),
          ]);

      final loaded = TransactionHistoryState.initial().copyWith(
        isLoading: false,
        items: [
          _tx(
            id: 1,
            type: TransactionType.expense,
            amount: 10,
            date: DateTime(2025, 1, 15, 10),
          ),
        ],
        hasMore: false,
      );

      when(() => cubit.state).thenReturn(loaded);
      whenListen<TransactionHistoryState>(
        cubit,
        Stream.fromIterable([loaded]),
        initialState: loaded,
      );

      await tester.pumpWidget(_buildApp());
      await _stablePump(tester);

      expect(find.text(AppStrings.transactionHistoryTitle), findsOneWidget);
    },
  );
}
