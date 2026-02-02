import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker_app/core/error/exception_mapper.dart';
import 'package:finance_tracker_app/core/utils/app_logger.dart';

import '../../domain/entities/budget.dart';
import '../../domain/usecases/get_budgets.dart';
import '../../domain/usecases/create_budget.dart';
import '../../domain/usecases/update_budget.dart';
import '../../domain/usecases/delete_budget.dart';

import 'budgets_state.dart';

class BudgetsCubit extends Cubit<BudgetsState> {
  final GetBudgets _getBudgets;
  final CreateBudget _createBudget;
  final UpdateBudget _updateBudget;
  final DeleteBudget _deleteBudget;

  BudgetsCubit({
    required GetBudgets getBudgets,
    required CreateBudget createBudget,
    required UpdateBudget updateBudget,
    required DeleteBudget deleteBudget,
  })  : _getBudgets = getBudgets,
        _createBudget = createBudget,
        _updateBudget = updateBudget,
        _deleteBudget = deleteBudget,
        super(BudgetsState.initial());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final list = await _getBudgets();
      emit(state.copyWith(isLoading: false, budgets: list));
    } catch (e, st) {
      AppLogger.repository('BudgetsCubit.load failed', error: e, stackTrace: st);
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: ExceptionMapper.map(e).toString(),
        ),
      );
    }
  }

  Future<void> refresh() => load();

  /// Dùng cho SetBudgetScreen:
  /// - Nếu đã có budget cho (month + categoryId) => update
  /// - Nếu chưa có => create
  ///
  /// (Không cần RPC; dùng data real từ API getMyBudgets)
  Future<void> createOrUpdate({
    required int categoryId,
    required double amount,
    required int month,
  }) async {
    emit(state.copyWith(isSaving: true, errorMessage: null, lastCreatedOrUpdated: null));
    try {
      // đảm bảo có list để check
      final current = state.budgets.isEmpty ? await _getBudgets() : state.budgets;

      final existed = current.where((b) => b.categoryId == categoryId && b.month == month).toList();
      Budget saved;

      if (existed.isNotEmpty) {
        final b = existed.first;
        saved = await _updateBudget(
          budgetId: b.id,
          amount: amount,
          categoryId: categoryId,
          month: month,
        );
        final nextList = current.map((x) => x.id == saved.id ? saved : x).toList();
        emit(state.copyWith(isSaving: false, budgets: nextList, lastCreatedOrUpdated: saved));
      } else {
        saved = await _createBudget(categoryId: categoryId, amount: amount, month: month);
        final nextList = [...current, saved]..sort((a, b) => a.month.compareTo(b.month));
        emit(state.copyWith(isSaving: false, budgets: nextList, lastCreatedOrUpdated: saved));
      }
    } catch (e, st) {
      AppLogger.repository('BudgetsCubit.createOrUpdate failed', error: e, stackTrace: st);
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: ExceptionMapper.map(e).toString(),
        ),
      );
    }
  }

  Future<void> update({
    required int budgetId,
    double? amount,
    int? categoryId,
    int? month,
  }) async {
    emit(state.copyWith(isSaving: true, errorMessage: null, lastCreatedOrUpdated: null));
    try {
      final saved = await _updateBudget(
        budgetId: budgetId,
        amount: amount,
        categoryId: categoryId,
        month: month,
      );

      final nextList = state.budgets.map((x) => x.id == saved.id ? saved : x).toList()
        ..sort((a, b) => a.month.compareTo(b.month));

      emit(state.copyWith(isSaving: false, budgets: nextList, lastCreatedOrUpdated: saved));
    } catch (e, st) {
      AppLogger.repository('BudgetsCubit.update failed', error: e, stackTrace: st);
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: ExceptionMapper.map(e).toString(),
        ),
      );
    }
  }

  Future<void> delete({required int budgetId}) async {
    emit(state.copyWith(deletingBudgetId: budgetId, errorMessage: null));
    try {
      await _deleteBudget(budgetId: budgetId);
      final nextList = state.budgets.where((b) => b.id != budgetId).toList();
      emit(state.copyWith(deletingBudgetId: null, budgets: nextList));
    } catch (e, st) {
      AppLogger.repository('BudgetsCubit.delete failed', error: e, stackTrace: st);
      emit(
        state.copyWith(
          deletingBudgetId: null,
          errorMessage: ExceptionMapper.map(e).toString(),
        ),
      );
    }
  }

  void clearLastSaved() {
    if (state.lastCreatedOrUpdated != null) {
      emit(state.copyWith(lastCreatedOrUpdated: null));
    }
  }
}
