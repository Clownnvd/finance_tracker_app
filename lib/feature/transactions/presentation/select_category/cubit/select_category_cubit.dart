import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker_app/core/error/exception_mapper.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/usecases/get_categories.dart';

import 'select_category_state.dart';

class SelectCategoryCubit extends Cubit<SelectCategoryState> {
  final GetCategories _getCategories;

  SelectCategoryCubit({
    required GetCategories getCategories,
    int? selectedCategoryId,
  })  : _getCategories = getCategories,
        super(SelectCategoryState.initial(selectedCategoryId: selectedCategoryId));

  Future<void> load({bool force = false}) async {
    if (state.isLoading && !force) return;

    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final categories = await _getCategories();

      final expense = <CategoryEntity>[];
      final income = <CategoryEntity>[];

      for (final c in categories) {
        if (c.type == TransactionType.expense) {
          expense.add(c);
        } else {
          income.add(c);
        }
      }

      emit(state.copyWith(
        isLoading: false,
        expense: expense,
        income: income,
        clearError: true,
      ));
    } catch (e) {
      final mapped = ExceptionMapper.map(e);
      emit(state.copyWith(
        isLoading: false,
        error: mapped.toString(),
      ));
    }
  }

  void select(CategoryEntity category) {
    emit(state.copyWith(selectedCategoryId: category.id));
  }
}
