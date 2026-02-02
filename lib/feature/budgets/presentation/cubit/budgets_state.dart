import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/budget.dart';

part 'budgets_state.freezed.dart';

@freezed
abstract class BudgetsState with _$BudgetsState {
  const factory BudgetsState({
    required bool isLoading,
    required bool isSaving,
    String? errorMessage,

    required List<Budget> budgets,

    // UI helper
    Budget? lastCreatedOrUpdated,
    int? deletingBudgetId,
  }) = _BudgetsState;

  factory BudgetsState.initial() => const BudgetsState(
        isLoading: true,
        isSaving: false,
        errorMessage: null,
        budgets: <Budget>[],
        lastCreatedOrUpdated: null,
        deletingBudgetId: null,
      );
}
