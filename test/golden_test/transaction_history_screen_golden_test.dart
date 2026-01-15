import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';

import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/core/di/di.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/usecases/get_categories.dart';

import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/cubit/transaction_history_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/cubit/transaction_history_state.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/pages/transaction_history_screen.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';

class MockTransactionHistoryCubit extends MockCubit<TransactionHistoryState>
    implements TransactionHistoryCubit {}

class MockGetCategories extends Mock implements GetCategories {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  setUp(() async {
    cubit = MockTransactionHistoryCubit();
    mockGetCategories = MockGetCategories();

    if (getIt.isRegistered<GetCategories>()) {
      await getIt.unregister<GetCategories>();
    }
    getIt.registerSingleton<GetCategories>(mockGetCategories);
  });

  tearDown(() async {
    if (getIt.isRegistered<GetCategories>()) {
      await getIt.unregister<GetCategories>();
    }
  });

  group('TransactionHistoryScreen golden', () {
    testWidgets('initial blocking loading (categories loading + cubit loading)', (tester) async {
      when(() => mockGetCategories.call()).thenAnswer((_) async => const [
            CategoryEntity(id: 1, name: 'Food', type: TransactionType.expense, icon: 'food'),
          ]);

      final s = TransactionHistoryState.initial().copyWith(isLoading: true);

      when(() => cubit.state).thenReturn(s);
      whenListen<TransactionHistoryState>(
        cubit,
        Stream.fromIterable([s]),
        initialState: s,
      );

      when(() => cubit.load(from: any(named: 'from'), to: any(named: 'to')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(buildGoldenApp(cubit));
      await tester.pump(); // post frame + first paints
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(TransactionHistoryScreen),
        matchesGoldenFile('goldens/transaction_history_screen_loading.png'),
      );
    });

    testWidgets('loaded with items', (tester) async {
      when(() => mockGetCategories.call()).thenAnswer((_) async => const [
            CategoryEntity(id: 1, name: 'Food', type: TransactionType.expense, icon: 'food'),
            CategoryEntity(id: 10, name: 'Salary', type: TransactionType.income, icon: 'salary'),
          ]);

      final s = TransactionHistoryState.initial().copyWith(
        isLoading: false,
        items: [
          tx(id: 2, type: TransactionType.expense, amount: 80, date: DateTime(2025, 1, 15, 10)),
          tx(id: 3, type: TransactionType.income, amount: 200, date: DateTime(2025, 1, 15, 9)),
        ],
        hasMore: false,
      );

      when(() => cubit.state).thenReturn(s);
      whenListen<TransactionHistoryState>(
        cubit,
        const Stream<TransactionHistoryState>.empty(),
        initialState: s,
      );

      when(() => cubit.load(from: any(named: 'from'), to: any(named: 'to')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(buildGoldenApp(cubit));
      await tester.pump(); // post frame
      await tester.pumpAndSettle();

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
          tx(id: 1, type: TransactionType.expense, amount: 10, date: DateTime(2025, 1, 10, 10)),
        ],
        hasMore: false,
      );

      when(() => cubit.state).thenReturn(s);
      whenListen<TransactionHistoryState>(
        cubit,
        const Stream<TransactionHistoryState>.empty(),
        initialState: s,
      );

      when(() => cubit.load(from: any(named: 'from'), to: any(named: 'to')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(buildGoldenApp(cubit));
      await tester.pump(); // post frame
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(TransactionHistoryScreen),
        matchesGoldenFile('goldens/transaction_history_screen_category_error.png'),
      );
    });

    testWidgets('cubit error shown (HistoryList should render error UI)', (tester) async {
      when(() => mockGetCategories.call()).thenAnswer((_) async => const [
            CategoryEntity(id: 1, name: 'Food', type: TransactionType.expense, icon: 'food'),
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

      when(() => cubit.load(from: any(named: 'from'), to: any(named: 'to')))
          .thenAnswer((_) async {});

      await tester.pumpWidget(buildGoldenApp(cubit));
      await tester.pump(); // post frame
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(TransactionHistoryScreen),
        matchesGoldenFile('goldens/transaction_history_screen_error.png'),
      );
    });
  });
}
