import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/cubit/select_category_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/cubit/select_category_state.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/pages/select_category_screen.dart';

class MockSelectCategoryCubit extends MockCubit<SelectCategoryState>
    implements SelectCategoryCubit {}

class _FakeRoute extends Fake implements Route<dynamic> {}

Future<void> _stablePump(WidgetTester tester) async {
  // Flush microtasks + async scheduling safely.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSelectCategoryCubit cubit;

  const expense1 = CategoryEntity(
    id: 1,
    name: 'Food',
    type: TransactionType.expense,
    icon: 'food',
  );

  const income1 = CategoryEntity(
    id: 10,
    name: 'Salary',
    type: TransactionType.income,
    icon: 'salary',
  );

  setUpAll(() {
    // Navigator fallback (when verify/capture routes).
    registerFallbackValue(_FakeRoute());

    // State fallback (for MockCubit internals).
    registerFallbackValue(SelectCategoryState.initial());

    // IMPORTANT:
    // Mocktail needs a fallback value when you use any()/captureAny()
    // for a parameter of type CategoryEntity (e.g. cubit.select(any())).
    registerFallbackValue(const CategoryEntity(
      id: 999,
      name: 'fallback',
      type: TransactionType.expense,
      icon: 'fallback',
    ));
  });

  setUp(() {
    cubit = MockSelectCategoryCubit();

    // Screen calls these, so always stub them to avoid:
    // "Null is not a subtype of Future<void>"
    when(() => cubit.load()).thenAnswer((_) async {});
    when(() => cubit.load(force: any(named: 'force'))).thenAnswer((_) async {});

    // select() returns void, so just stub it.
    when(() => cubit.select(any())).thenReturn(null);
  });

  Widget _buildApp({
    required SelectCategoryState state,
    Stream<SelectCategoryState>? stream,
  }) {
    when(() => cubit.state).thenReturn(state);
    whenListen<SelectCategoryState>(
      cubit,
      stream ?? const Stream<SelectCategoryState>.empty(),
      initialState: state,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
      home: BlocProvider<SelectCategoryCubit>.value(
        value: cubit,
        child: const SelectCategoryScreen(),
      ),
    );
  }

  testWidgets(
    'initState schedules cubit.load() via microtask',
    (tester) async {
      final s = SelectCategoryState.initial();

      await tester.pumpWidget(_buildApp(state: s));

      // Microtask runs on the next pump.
      await tester.pump();

      verify(() => cubit.load()).called(1);
    },
  );

  testWidgets(
    'shows CircularProgressIndicator when loading and lists are empty',
    (tester) async {
      final s = SelectCategoryState.initial().copyWith(isLoading: true);

      await tester.pumpWidget(
        _buildApp(
          state: s,
          stream: Stream<SelectCategoryState>.fromIterable([s]),
        ),
      );
      await _stablePump(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'renders title + sections when loaded',
    (tester) async {
      final loaded = SelectCategoryState.initial().copyWith(
        isLoading: false,
        expense: const [expense1],
        income: const [income1],
        clearError: true,
      );

      await tester.pumpWidget(
        _buildApp(
          state: loaded,
          stream: Stream<SelectCategoryState>.fromIterable([loaded]),
        ),
      );
      await _stablePump(tester);

      expect(find.text(AppStrings.selectCategoryTitle), findsOneWidget);
      expect(find.text(AppStrings.expenseUpper), findsOneWidget);
      expect(find.text(AppStrings.incomeUpper), findsOneWidget);

      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Salary'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping an item pops and returns CategoryEntity',
    (tester) async {
      final loaded = SelectCategoryState.initial(selectedCategoryId: null).copyWith(
        isLoading: false,
        expense: const [expense1],
        income: const [income1],
        clearError: true,
      );

      when(() => cubit.state).thenReturn(loaded);
      whenListen<SelectCategoryState>(
        cubit,
        Stream<SelectCategoryState>.fromIterable([loaded]),
        initialState: loaded,
      );

      CategoryEntity? popped;

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final res = await Navigator.of(context).push<CategoryEntity>(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider<SelectCategoryCubit>.value(
                          value: cubit,
                          child: const SelectCategoryScreen(),
                        ),
                      ),
                    );
                    popped = res;
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // Tap by label (should be visible in the list).
      await tester.tap(find.text('Food'));
      await tester.pumpAndSettle();

      expect(popped, isNotNull);
      expect(popped!.id, equals(expense1.id));

      // Verify select called with a CategoryEntity.
      // We avoid verifying exact instance identity to keep it robust.
      verify(() => cubit.select(any())).called(1);
    },
  );

  testWidgets(
    'refresh calls cubit.load(force: true) (stable: call RefreshIndicator.onRefresh directly)',
    (tester) async {
      final loaded = SelectCategoryState.initial().copyWith(
        isLoading: false,
        expense: const [expense1],
        income: const [income1],
        clearError: true,
      );

      await tester.pumpWidget(_buildApp(state: loaded));
      await _stablePump(tester);

      final riFinder = find.byType(RefreshIndicator);
      expect(riFinder, findsOneWidget);

      final ri = tester.widget<RefreshIndicator>(riFinder);
      await ri.onRefresh();
      await tester.pump();

      verify(() => cubit.load(force: true)).called(1);
    },
  );

  testWidgets(
    'shows SnackBar when error becomes non-empty',
    (tester) async {
      final s0 = SelectCategoryState.initial();
      final s1 = s0.copyWith(error: 'Oops');

      await tester.pumpWidget(
        _buildApp(
          state: s0,
          stream: Stream<SelectCategoryState>.fromIterable([s1]),
        ),
      );

      await _stablePump(tester);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Oops'), findsOneWidget);
    },
  );
}
