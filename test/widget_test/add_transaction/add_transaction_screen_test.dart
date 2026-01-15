import 'package:bloc_test/bloc_test.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/pages/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/cubit/add_transaction_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/cubit/add_transaction_state.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';

class MockAddTransactionCubit extends MockCubit<AddTransactionState>
    implements AddTransactionCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockAddTransactionCubit cubit;
  late MockNavigatorObserver navObserver;

  const incomeCat = CategoryEntity(
    id: 1,
    name: 'Salary',
    type: TransactionType.income,
    icon: 'salary',
  );

  setUp(() {
    cubit = MockAddTransactionCubit();
    navObserver = MockNavigatorObserver();
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    required AddTransactionState state,
    Stream<AddTransactionState>? stream,
  }) async {
    when(() => cubit.state).thenReturn(state);
    whenListen(
      cubit,
      stream ?? const Stream.empty(),
      initialState: state,
    );

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [navObserver],
        home: BlocProvider<AddTransactionCubit>.value(
          value: cubit,
          child: const AddTransactionScreen(),
        ),
      ),
    );

    // settle first frame
    await tester.pump();
  }

  group('AddTransactionScreen - rendering', () {
    testWidgets('renders title and Save button', (tester) async {
      await pumpScreen(
        tester,
        state: AddTransactionState.initial(),
      );

      expect(find.text('Add transaction'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);
    });

    testWidgets('Save button is disabled when cannot submit', (tester) async {
      final s = AddTransactionState.initial(); // amount=0, category=null => canSubmit false
      await pumpScreen(tester, state: s);

      final btn = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Save'),
      );
      expect(btn.onPressed, isNull);
    });

    testWidgets('shows LinearProgressIndicator overlay when loading', (tester) async {
      final s = AddTransactionState.initial().copyWith(isLoading: true);
      await pumpScreen(tester, state: s);

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });

  group('AddTransactionScreen - snackbar', () {
    testWidgets('shows SnackBar when state.error is set', (tester) async {
      final initial = AddTransactionState.initial();
      final errorState = initial.copyWith(error: 'Boom');

      await pumpScreen(
        tester,
        state: initial,
        stream: Stream.fromIterable([errorState]),
      );

      await tester.pump(); // allow listener to run
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Boom'), findsOneWidget);
    });
  });

  group('AddTransactionScreen - submit flow', () {
    testWidgets('tap Save -> calls cubit.submit; when true => shows success SnackBar and pop(true)', (tester) async {
      final canSubmitState = AddTransactionState.initial().copyWith(
        category: incomeCat,
        amount: 100,
        // date/note keep default
      );

      when(() => cubit.submit()).thenAnswer((_) async => true);

      await pumpScreen(tester, state: canSubmitState);

      // enabled
      final btnFinder = find.widgetWithText(ElevatedButton, 'Save');
      final btn = tester.widget<ElevatedButton>(btnFinder);
      expect(btn.onPressed, isNotNull);

      await tester.tap(btnFinder);
      await tester.pump(); // start async
      await tester.pump(const Duration(milliseconds: 50));

      verify(() => cubit.submit()).called(1);

      // success snackbar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Transaction added'), findsOneWidget);

      // verify pop called with true (didPop route)
      verify(() => navObserver.didPop(any(), any())).called(1);
    });

    testWidgets('tap Save -> when submit returns false => does NOT pop', (tester) async {
      final canSubmitState = AddTransactionState.initial().copyWith(
        category: incomeCat,
        amount: 100,
      );

      when(() => cubit.submit()).thenAnswer((_) async => false);

      await pumpScreen(tester, state: canSubmitState);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pump();

      verify(() => cubit.submit()).called(1);

      // no navigation pop
      verifyNever(() => navObserver.didPop(any(), any()));
    });
  });
}
