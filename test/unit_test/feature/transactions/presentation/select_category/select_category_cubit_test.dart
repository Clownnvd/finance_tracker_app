import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/usecases/get_categories.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/cubit/select_category_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/cubit/select_category_state.dart';

class MockGetCategories extends Mock implements GetCategories {}

void main() {
  late MockGetCategories getCategories;

  setUp(() {
    getCategories = MockGetCategories();
  });

  const expense1 = CategoryEntity(id: 1, name: 'Food', type: TransactionType.expense, icon: 'food');
  const expense2 = CategoryEntity(id: 2, name: 'Rent', type: TransactionType.expense, icon: 'rent');
  const income1 = CategoryEntity(id: 10, name: 'Salary', type: TransactionType.income, icon: 'salary');

  SelectCategoryCubit build({int? selectedId}) => SelectCategoryCubit(
        getCategories: getCategories,
        selectedCategoryId: selectedId,
      );

  group('SelectCategoryCubit', () {
    blocTest<SelectCategoryCubit, SelectCategoryState>(
      'load success: splits categories into expense & income',
      build: () {
        when(() => getCategories()).thenAnswer((_) async => [expense1, income1, expense2]);
        return build(selectedId: 2);
      },
      act: (c) => c.load(),
      expect: () => [
        // loading
        SelectCategoryState.initial(selectedCategoryId: 2).copyWith(isLoading: true, clearError: true),
        // loaded
        SelectCategoryState.initial(selectedCategoryId: 2).copyWith(
          isLoading: false,
          expense: const [expense1, expense2],
          income: const [income1],
          clearError: true,
        ),
      ],
      verify: (_) {
        verify(() => getCategories()).called(1);
      },
    );

    blocTest<SelectCategoryCubit, SelectCategoryState>(
      'load does nothing when already loading and force=false',
      build: () {
        when(() => getCategories()).thenAnswer((_) async => [expense1]);
        return build();
      },
      seed: () => SelectCategoryState.initial().copyWith(isLoading: true),
      act: (c) => c.load(),
      expect: () => <SelectCategoryState>[],
      verify: (_) {
        verifyNever(() => getCategories());
      },
    );

    blocTest<SelectCategoryCubit, SelectCategoryState>(
  'load(force=true) runs even if currently loading',
  build: () {
    when(() => getCategories()).thenAnswer((_) async => [income1]);
    return build();
  },
  seed: () => SelectCategoryState.initial().copyWith(isLoading: true),
  act: (c) => c.load(force: true),
  expect: () => [
    isA<SelectCategoryState>()
        .having((s) => s.isLoading, 'isLoading', false)
        .having((s) => s.error, 'error', isNull)
        .having((s) => s.income, 'income', [income1])
        .having((s) => s.expense, 'expense', isEmpty),
  ],
  verify: (_) => verify(() => getCategories()).called(1),
);


    blocTest<SelectCategoryCubit, SelectCategoryState>(
      'select updates selectedCategoryId',
      build: () => build(selectedId: 1),
      act: (c) => c.select(income1),
      expect: () => [
        SelectCategoryState.initial(selectedCategoryId: 1).copyWith(selectedCategoryId: income1.id),
      ],
    );

    blocTest<SelectCategoryCubit, SelectCategoryState>(
      'load failure: emits error and isLoading=false',
      build: () {
        when(() => getCategories()).thenThrow(Exception('boom'));
        return build();
      },
      act: (c) => c.load(),
      expect: () => [
        SelectCategoryState.initial().copyWith(isLoading: true, clearError: true),
        predicate<SelectCategoryState>((s) =>
            s.isLoading == false && (s.error?.isNotEmpty ?? false)),
      ],
      verify: (_) => verify(() => getCategories()).called(1),
    );
  });
}
