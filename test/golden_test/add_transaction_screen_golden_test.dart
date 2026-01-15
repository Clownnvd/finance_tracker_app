import 'package:bloc_test/bloc_test.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/pages/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/cubit/add_transaction_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/cubit/add_transaction_state.dart';

class MockAddTransactionCubit extends MockCubit<AddTransactionState>
    implements AddTransactionCubit {}

Widget _buildGoldenApp(AddTransactionCubit cubit) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: BlocProvider<AddTransactionCubit>.value(
      value: cubit,
      child: const AddTransactionScreen(),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // For mocktail fallback (helps when any()/captureAny() is used internally)
    registerFallbackValue(AddTransactionState.initial());

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

  group('AddTransactionScreen golden', () {
    testWidgets('initial state', (tester) async {
      final cubit = MockAddTransactionCubit();
      final s = AddTransactionState.initial();

      when(() => cubit.state).thenReturn(s);
      whenListen<AddTransactionState>(
        cubit,
        const Stream<AddTransactionState>.empty(),
        initialState: s,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(AddTransactionScreen),
        matchesGoldenFile('goldens/add_transaction_screen_initial.png'),
      );
    });

    testWidgets('canSubmit state (Save enabled)', (tester) async {
      final cubit = MockAddTransactionCubit();

      const incomeCat = CategoryEntity(
        id: 1,
        name: 'Salary',
        type: TransactionType.income,
        icon: 'salary',
      );

      final s = AddTransactionState.initial().copyWith(
        category: incomeCat,
        type: TransactionType.income,
        amount: 120.5,
        note: 'Lunch',
        date: DateTime(2025, 6, 1),
      );

      when(() => cubit.state).thenReturn(s);
      whenListen<AddTransactionState>(
        cubit,
        const Stream<AddTransactionState>.empty(),
        initialState: s,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(AddTransactionScreen),
        matchesGoldenFile('goldens/add_transaction_screen_can_submit.png'),
      );
    });

    testWidgets('loading state', (tester) async {
      final cubit = MockAddTransactionCubit();

      final loading = AddTransactionState.initial().copyWith(isLoading: true);

      when(() => cubit.state).thenReturn(loading);
      whenListen<AddTransactionState>(
        cubit,
        Stream<AddTransactionState>.fromIterable([loading]),
        initialState: loading,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(AddTransactionScreen),
        matchesGoldenFile('goldens/add_transaction_screen_loading.png'),
      );
    });

    testWidgets('error state (shows SnackBar)', (tester) async {
      final cubit = MockAddTransactionCubit();

      final s0 = AddTransactionState.initial();
      final s1 = s0.copyWith(error: 'Amount must be greater than 0.');

      when(() => cubit.state).thenReturn(s1);
      whenListen<AddTransactionState>(
        cubit,
        Stream<AddTransactionState>.fromIterable([s1]),
        initialState: s0,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));

      // 1st frame: build initial
      await tester.pump();

      // allow BlocConsumer listener to show SnackBar + animations
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(AddTransactionScreen),
        matchesGoldenFile('goldens/add_transaction_screen_error.png'),
      );
    });
  });
}
