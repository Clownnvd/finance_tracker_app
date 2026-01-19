// test/golden_test/transaction_history_screen_golden_test.dart
//
// FULL FILE (UI-safe + no pumpAndSettle timeouts)
//
// Why your test was timing out:
// - TransactionHistoryScreen usually has ongoing animations/loaders (RefreshIndicator,
//   progress indicators, async category fetch, etc.). `pumpAndSettle()` waits until
//   there are NO scheduled frames anymore → it can hang forever.
//
// Fix:
// - Do NOT use pumpAndSettle() for these screens.
// - Pump a small, deterministic amount of time, then take the golden.
// - Stub every async method that can be called in initState (cubit.load + GetCategories).

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/core/di/di.dart'; // exposes getIt
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/usecases/get_categories.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/cubit/transaction_history_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/cubit/transaction_history_state.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/pages/transaction_history_screen.dart';

class MockTransactionHistoryCubit extends MockCubit<TransactionHistoryState>
    implements TransactionHistoryCubit {}

class MockGetCategories extends Mock implements GetCategories {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // -------------------------
  // Helpers (deterministic pumping)
  // -------------------------
  Future<void> pumpFor(
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

  // -------------------------
  // Mocks + DI
  // -------------------------
  late MockTransactionHistoryCubit cubit;
  late MockGetCategories mockGetCategories;

  TransactionEntity tx({
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

  Widget buildGoldenApp(TransactionHistoryCubit cubit) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: BlocProvider<TransactionHistoryCubit>.value(
        value: cubit,
        child: const TransactionHistoryScreen(currencySymbol: '₫'),
      ),
    );
  }

  setUpAll(() {
  registerFallbackValue(DateTime(2000, 1, 1));
});


  setUp(() async {
    cubit = MockTransactionHistoryCubit();
    mockGetCategories = MockGetCategories();

    if (getIt.isRegistered<GetCategories>()) {
      await getIt.unregister<GetCategories>();
    }
    getIt.registerSingleton<GetCategories>(mockGetCategories);

    // IMPORTANT: TransactionHistoryScreen calls cubit.load(...) in initState.
    // If this is not stubbed, mocktail returns null and you get:
    // "type 'Null' is not a subtype of type 'Future<void>'"
    when(() => cubit.load(from: any(named: 'from'), to: any(named: 'to')))
        .thenAnswer((_) async {});
    when(() => cubit.loadMore()).thenAnswer((_) async {});
    when(() => cubit.refresh()).thenAnswer((_) async {});
  });

  tearDown(() async {
    if (getIt.isRegistered<GetCategories>()) {
      await getIt.unregister<GetCategories>();
    }
  });

  group('TransactionHistoryScreen golden (UI-safe)', () {
    testWidgets(
        'initial blocking loading (categories loading + cubit loading)',
        (tester) async {
      when(() => mockGetCategories.call()).thenAnswer((_) async => const [
            CategoryEntity(
              id: 1,
              name: 'Food',
              type: TransactionType.expense,
              icon: 'food',
            ),
          ]);

      final s = TransactionHistoryState.initial().copyWith(isLoading: true);

      when(() => cubit.state).thenReturn(s);
      whenListen<TransactionHistoryState>(
        cubit,
        Stream<TransactionHistoryState>.fromIterable([s]),
        initialState: s,
      );

      await tester.pumpWidget(buildGoldenApp(cubit));

      // One frame to build + a short deterministic pump for layout/animations.
      await tester.pump();
      await pumpFor(tester, const Duration(milliseconds: 300));

      await expectLater(
        find.byType(TransactionHistoryScreen),
        matchesGoldenFile('goldens/transaction_history_screen_loading.png'),
      );
    });

    testWidgets('loaded with items', (tester) async {
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

      final s = TransactionHistoryState.initial().copyWith(
        isLoading: false,
        items: [
          tx(
            id: 2,
            type: TransactionType.expense,
            amount: 80,
            date: DateTime(2025, 1, 15, 10),
          ),
          tx(
            id: 3,
            type: TransactionType.income,
            amount: 200,
            date: DateTime(2025, 1, 15, 9),
          ),
        ],
        hasMore: false,
      );

      when(() => cubit.state).thenReturn(s);
      whenListen<TransactionHistoryState>(
        cubit,
        const Stream<TransactionHistoryState>.empty(),
        initialState: s,
      );

      await tester.pumpWidget(buildGoldenApp(cubit));
      await tester.pump();
      await pumpFor(tester, const Duration(milliseconds: 300));

      await expectLater(
        find.byType(TransactionHistoryScreen),
        matchesGoldenFile('goldens/transaction_history_screen_loaded.png'),
      );
    });

    testWidgets('category load failed banner', (tester) async {
      when(() => mockGetCategories.call()).thenThrow(Exception('cat fail'));

      final s = TransactionHistoryState.initial().copyWith(
        isLoading: false,
        items: [
          tx(
            id: 1,
            type: TransactionType.expense,
            amount: 10,
            date: DateTime(2025, 1, 10, 10),
          ),
        ],
        hasMore: false,
      );

      when(() => cubit.state).thenReturn(s);
      whenListen<TransactionHistoryState>(
        cubit,
        const Stream<TransactionHistoryState>.empty(),
        initialState: s,
      );

      await tester.pumpWidget(buildGoldenApp(cubit));
      await tester.pump();

      // Give time for category fetch Future to complete and banner to render.
      await pumpFor(tester, const Duration(milliseconds: 600));

      await expectLater(
        find.byType(TransactionHistoryScreen),
        matchesGoldenFile(
          'goldens/transaction_history_screen_category_error.png',
        ),
      );
    });

    testWidgets('cubit error shown (HistoryList renders error UI)', (tester) async {
      when(() => mockGetCategories.call()).thenAnswer((_) async => const [
            CategoryEntity(
              id: 1,
              name: 'Food',
              type: TransactionType.expense,
              icon: 'food',
            ),
          ]);

      final s = TransactionHistoryState.initial().copyWith(
        isLoading: false,
        error: 'Network error',
        items: const <TransactionEntity>[],
        hasMore: true,
      );

      when(() => cubit.state).thenReturn(s);
      whenListen<TransactionHistoryState>(
        cubit,
        const Stream<TransactionHistoryState>.empty(),
        initialState: s,
      );

      await tester.pumpWidget(buildGoldenApp(cubit));
      await tester.pump();
      await pumpFor(tester, const Duration(milliseconds: 300));

      await expectLater(
        find.byType(TransactionHistoryScreen),
        matchesGoldenFile('goldens/transaction_history_screen_error.png'),
      );
    });
  });
}
