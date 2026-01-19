import 'package:bloc_test/bloc_test.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/pages/select_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/cubit/select_category_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/cubit/select_category_state.dart';

class MockSelectCategoryCubit extends MockCubit<SelectCategoryState>
    implements SelectCategoryCubit {}

Widget _buildGoldenApp(SelectCategoryCubit cubit) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: BlocProvider<SelectCategoryCubit>.value(
      value: cubit,
      child: const SelectCategoryScreen(),
    ),
  );
}

/// Pumps a few frames without waiting forever (avoids pumpAndSettle timeouts
/// when there are indeterminate animations/spinners).
Future<void> _stablePump(WidgetTester tester) async {
  await tester.pump(); // first frame
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
  await tester.pump(const Duration(milliseconds: 50));
}

/// Stubs async/side-effect methods that SelectCategoryScreen might call in initState.
/// IMPORTANT: load() must return Future<void> (not null).
void _stubCubitMethods(MockSelectCategoryCubit cubit) {
  when(() => cubit.load(force: any(named: 'force'))).thenAnswer((_) async {});
  // If your UI triggers select() in tests (usually not needed for golden), stub it too.
  when(() => cubit.select(any())).thenReturn(null);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(SelectCategoryState.initial());
    registerFallbackValue(
      const CategoryEntity(
        id: 0,
        name: 'fallback',
        type: TransactionType.expense,
        icon: 'fallback',
      ),
    );
  });

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

  group('SelectCategoryScreen golden (UI-safe)', () {
    testWidgets('loading state (initial loading)', (tester) async {
      final cubit = MockSelectCategoryCubit();
      _stubCubitMethods(cubit);

      final s = SelectCategoryState.initial().copyWith(isLoading: true);

      when(() => cubit.state).thenReturn(s);
      whenListen<SelectCategoryState>(
        cubit,
        Stream<SelectCategoryState>.fromIterable([s]),
        initialState: s,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _stablePump(tester);

      await expectLater(
        find.byType(SelectCategoryScreen),
        matchesGoldenFile('goldens/select_category_screen_loading.png'),
      );
    });

    testWidgets('loaded state (lists + selected item)', (tester) async {
      final cubit = MockSelectCategoryCubit();
      _stubCubitMethods(cubit);

      final s = SelectCategoryState.initial(selectedCategoryId: 1).copyWith(
        isLoading: false,
        expense: const [expense1],
        income: const [income1],
        clearError: true,
      );

      when(() => cubit.state).thenReturn(s);
      whenListen<SelectCategoryState>(
        cubit,
        const Stream<SelectCategoryState>.empty(),
        initialState: s,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _stablePump(tester);

      await expectLater(
        find.byType(SelectCategoryScreen),
        matchesGoldenFile('goldens/select_category_screen_loaded.png'),
      );
    });

    testWidgets('loading footer (LinearProgressIndicator visible)', (tester) async {
      final cubit = MockSelectCategoryCubit();
      _stubCubitMethods(cubit);

      final s = SelectCategoryState.initial().copyWith(
        // Your UI may show a footer loader when isLoading=true and lists exist.
        isLoading: true,
        expense: const [expense1],
        income: const [income1],
        clearError: true,
      );

      when(() => cubit.state).thenReturn(s);
      whenListen<SelectCategoryState>(
        cubit,
        const Stream<SelectCategoryState>.empty(),
        initialState: s,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await _stablePump(tester);

      await expectLater(
        find.byType(SelectCategoryScreen),
        matchesGoldenFile('goldens/select_category_screen_loading_footer.png'),
      );
    });

    testWidgets('error state (SnackBar visible)', (tester) async {
      final cubit = MockSelectCategoryCubit();
      _stubCubitMethods(cubit);

      final s0 = SelectCategoryState.initial();
      final s1 = s0.copyWith(error: 'Something went wrong');

      when(() => cubit.state).thenReturn(s1);
      whenListen<SelectCategoryState>(
        cubit,
        Stream<SelectCategoryState>.fromIterable([s1]),
        initialState: s0,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));

      // Let BlocConsumer listener run and show SnackBar.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await _stablePump(tester);

      await expectLater(
        find.byType(SelectCategoryScreen),
        matchesGoldenFile('goldens/select_category_screen_error.png'),
      );
    });
  });
}
