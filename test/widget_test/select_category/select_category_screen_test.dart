import 'package:bloc_test/bloc_test.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/pages/select_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/cubit/select_category_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/cubit/select_category_state.dart';

class MockSelectCategoryCubit extends MockCubit<SelectCategoryState>
    implements SelectCategoryCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockSelectCategoryCubit cubit;
  late MockNavigatorObserver navObserver;

  const expense1 = CategoryEntity(id: 1, name: 'Food', type: TransactionType.expense, icon: 'food');
  const income1 = CategoryEntity(id: 10, name: 'Salary', type: TransactionType.income, icon: 'salary');

  Widget buildApp(SelectCategoryCubit cubit) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [navObserver],
      home: BlocProvider<SelectCategoryCubit>.value(
        value: cubit,
        child: const SelectCategoryScreen(),
      ),
    );
  }

  setUp(() {
    cubit = MockSelectCategoryCubit();
    navObserver = MockNavigatorObserver();
  });

  testWidgets('calls cubit.load() on initState (microtask)', (tester) async {
    when(() => cubit.state).thenReturn(SelectCategoryState.initial());
    whenListen(
      cubit,
      const Stream<SelectCategoryState>.empty(),
      initialState: SelectCategoryState.initial(),
    );

    when(() => cubit.load()).thenAnswer((_) async {});

    await tester.pumpWidget(buildApp(cubit));

    // Let microtask run
    await tester.pump();

    verify(() => cubit.load()).called(1);
  });

  testWidgets('shows CircularProgressIndicator when loading and lists empty', (tester) async {
    final s = SelectCategoryState.initial().copyWith(isLoading: true);

    when(() => cubit.state).thenReturn(s);
    whenListen(
      cubit,
      Stream<SelectCategoryState>.fromIterable([s]),
      initialState: s,
    );

    await tester.pumpWidget(buildApp(cubit));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders sections and pops with CategoryEntity when tapping item', (tester) async {
    final loaded = SelectCategoryState.initial(selectedCategoryId: null).copyWith(
      isLoading: false,
      expense: const [expense1],
      income: const [income1],
      clearError: true,
    );

    when(() => cubit.state).thenReturn(loaded);
    whenListen(
      cubit,
      Stream<SelectCategoryState>.fromIterable([loaded]),
      initialState: loaded,
    );

    // We want a route to pop from.
    final result = await tester.runAsync(() async {
      CategoryEntity? popped;

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [navObserver],
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

      expect(find.text('Select category'), findsOneWidget);

      // Tap category item by its name
      await tester.tap(find.text('Food'));
      await tester.pumpAndSettle();

      expect(popped, isNotNull);
      expect(popped!.id, expense1.id);

      return popped;
    });

    expect(result, isA<CategoryEntity>());
  });

  testWidgets('pull-to-refresh calls load(force:true)', (tester) async {
    final loaded = SelectCategoryState.initial().copyWith(
      isLoading: false,
      expense: const [expense1],
      income: const [income1],
      clearError: true,
    );

    when(() => cubit.state).thenReturn(loaded);
    whenListen(
      cubit,
      const Stream<SelectCategoryState>.empty(),
      initialState: loaded,
    );

    when(() => cubit.load(force: true)).thenAnswer((_) async {});

    await tester.pumpWidget(buildApp(cubit));
    await tester.pumpAndSettle();

    // Trigger RefreshIndicator (drag down enough)
    await tester.drag(find.byType(ListView), const Offset(0, 500));
    await tester.pump(); // start refresh
    await tester.pump(const Duration(seconds: 1));

    verify(() => cubit.load(force: true)).called(1);
  });

  testWidgets('shows SnackBar when error appears', (tester) async {
    final s0 = SelectCategoryState.initial();
    final s1 = s0.copyWith(error: 'Oops');

    when(() => cubit.state).thenReturn(s1);
    whenListen(
      cubit,
      Stream<SelectCategoryState>.fromIterable([s1]),
      initialState: s0,
    );

    await tester.pumpWidget(buildApp(cubit));
    await tester.pump(); // allow listener

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Oops'), findsOneWidget);
  });
}
