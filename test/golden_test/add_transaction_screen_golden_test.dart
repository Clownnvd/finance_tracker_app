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

Future<void> _pumpGoldenFrame(WidgetTester tester) async {
  // Avoid pumpAndSettle in states with infinite animations (progress indicators, text cursor).
  await tester.pump(); // first build
  await tester.pump(const Duration(milliseconds: 200)); // allow layout/animations to start
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Mocktail fallbacks
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

  group('AddTransactionScreen golden (NEW UI)', () {
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
      await _pumpGoldenFrame(tester);

      await expectLater(
        find.byType(AddTransactionScreen),
        matchesGoldenFile('goldens/add_transaction_screen_initial.png'),
      );
    });

    testWidgets('canSubmit state (Add enabled)', (tester) async {
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
      await _pumpGoldenFrame(tester);

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

      // IMPORTANT: do NOT pumpAndSettle here (loading indicators never settle).
      await _pumpGoldenFrame(tester);

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

      // Build + allow BlocConsumer listener to show SnackBar.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Do not pumpAndSettle if SnackBar animations or cursors keep ticking.
      await expectLater(
        find.byType(AddTransactionScreen),
        matchesGoldenFile('goldens/add_transaction_screen_error.png'),
      );
    });
  });
}
