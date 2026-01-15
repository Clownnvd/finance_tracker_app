import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';

import 'package:finance_tracker_app/core/di/di.dart'; // contains `final getIt = GetIt.instance;`
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/usecases/get_categories.dart';
import 'package:finance_tracker_app/feature/transactions/domain/repositories/transactions_repository.dart';

import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/cubit/transaction_history_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/cubit/transaction_history_state.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/pages/transaction_history_screen.dart';

class MockTransactionHistoryCubit extends MockCubit<TransactionHistoryState>
    implements TransactionHistoryCubit {}

class MockGetCategories extends Mock implements GetCategories {}

void main() {
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

  setUp(() async {
    cubit = MockTransactionHistoryCubit();
    mockGetCategories = MockGetCategories();

    // Reset GetIt between tests
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

  Widget buildApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<TransactionHistoryCubit>.value(
        value: cubit,
        child: const TransactionHistoryScreen(currencySymbol: '₫'),
      ),
    );
  }

  testWidgets('initState loads categories then calls cubit.load()', (tester) async {
    when(() => mockGetCategories.call()).thenAnswer((_) async => const [
          CategoryEntity(id: 1, name: 'Food', type: TransactionType.expense, icon: 'food'),
          CategoryEntity(id: 10, name: 'Salary', type: TransactionType.income, icon: 'salary'),
        ]);

    when(() => cubit.state).thenReturn(TransactionHistoryState.initial());
    whenListen(cubit, const Stream<TransactionHistoryState>.empty(),
        initialState: TransactionHistoryState.initial());

    when(() => cubit.load(from: any(named: 'from'), to: any(named: 'to')))
        .thenAnswer((_) async {});

    await tester.pumpWidget(buildApp());

    // allow post frame callback
    await tester.pump();

    verify(() => mockGetCategories.call()).called(1);
    verify(() => cubit.load(from: any(named: 'from'), to: any(named: 'to'))).called(1);
  });

  testWidgets('shows banner when category load fails', (tester) async {
    when(() => mockGetCategories.call()).thenThrow(Exception('cat boom'));

    when(() => cubit.state).thenReturn(TransactionHistoryState.initial());
    whenListen(cubit, const Stream<TransactionHistoryState>.empty(),
        initialState: TransactionHistoryState.initial());

    when(() => cubit.load(from: any(named: 'from'), to: any(named: 'to')))
        .thenAnswer((_) async {});

    await tester.pumpWidget(buildApp());
    await tester.pump(); // post frame

    expect(find.textContaining('Category load failed:'), findsOneWidget);
  });

  testWidgets('tap appbar reload categories calls _loadCategories again', (tester) async {
    when(() => mockGetCategories.call()).thenAnswer((_) async => const [
          CategoryEntity(id: 1, name: 'Food', type: TransactionType.expense, icon: 'food'),
        ]);

    when(() => cubit.state).thenReturn(TransactionHistoryState.initial());
    whenListen(cubit, const Stream<TransactionHistoryState>.empty(),
        initialState: TransactionHistoryState.initial());

    when(() => cubit.load(from: any(named: 'from'), to: any(named: 'to')))
        .thenAnswer((_) async {});

    await tester.pumpWidget(buildApp());
    await tester.pump(); // first load categories

    // tap refresh icon in appbar
    await tester.tap(find.byIcon(Icons.refresh_rounded));
    await tester.pump();

    verify(() => mockGetCategories.call()).called(greaterThanOrEqualTo(2));
  });

  testWidgets('when state has items, renders Transaction History title', (tester) async {
    when(() => mockGetCategories.call()).thenAnswer((_) async => const [
          CategoryEntity(id: 1, name: 'Food', type: TransactionType.expense, icon: 'food'),
        ]);

    final loaded = TransactionHistoryState.initial().copyWith(
      isLoading: false,
      items: [
        tx(id: 1, type: TransactionType.expense, amount: 10, date: DateTime(2025, 1, 15, 10)),
      ],
      hasMore: false,
    );

    when(() => cubit.state).thenReturn(loaded);
    whenListen(cubit, Stream.fromIterable([loaded]), initialState: loaded);

    when(() => cubit.load(from: any(named: 'from'), to: any(named: 'to')))
        .thenAnswer((_) async {});

    await tester.pumpWidget(buildApp());
    await tester.pump(); // post frame
    await tester.pumpAndSettle();

    expect(find.text('Transaction History'), findsOneWidget);
  });
}
