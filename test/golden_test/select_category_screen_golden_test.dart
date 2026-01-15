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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(SelectCategoryState.initial());
  });

  const expense1 = CategoryEntity(id: 1, name: 'Food', type: TransactionType.expense, icon: 'food');
  const income1 = CategoryEntity(id: 10, name: 'Salary', type: TransactionType.income, icon: 'salary');

  group('SelectCategoryScreen golden', () {
    testWidgets('initial loading', (tester) async {
      final cubit = MockSelectCategoryCubit();
      final s = SelectCategoryState.initial().copyWith(isLoading: true);

      when(() => cubit.state).thenReturn(s);
      whenListen<SelectCategoryState>(
        cubit,
        Stream<SelectCategoryState>.fromIterable([s]),
        initialState: s,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SelectCategoryScreen),
        matchesGoldenFile('goldens/select_category_screen_loading.png'),
      );
    });

    testWidgets('loaded state', (tester) async {
      final cubit = MockSelectCategoryCubit();

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
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SelectCategoryScreen),
        matchesGoldenFile('goldens/select_category_screen_loaded.png'),
      );
    });

    testWidgets('loading footer (LinearProgressIndicator visible)', (tester) async {
      final cubit = MockSelectCategoryCubit();

      final s = SelectCategoryState.initial().copyWith(
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
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SelectCategoryScreen),
        matchesGoldenFile('goldens/select_category_screen_loading_footer.png'),
      );
    });

    testWidgets('error snackbar', (tester) async {
      final cubit = MockSelectCategoryCubit();

      final s0 = SelectCategoryState.initial();
      final s1 = s0.copyWith(error: 'Something went wrong');

      when(() => cubit.state).thenReturn(s1);
      whenListen<SelectCategoryState>(
        cubit,
        Stream<SelectCategoryState>.fromIterable([s1]),
        initialState: s0,
      );

      await tester.pumpWidget(_buildGoldenApp(cubit));
      await tester.pump(); // allow listener
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(SelectCategoryScreen),
        matchesGoldenFile('goldens/select_category_screen_error.png'),
      );
    });
  });
}
