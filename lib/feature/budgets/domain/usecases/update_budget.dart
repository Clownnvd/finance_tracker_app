import '../entities/budget.dart';
import '../repositories/budgets_repository.dart';

class UpdateBudget {
  final BudgetsRepository _repo;
  const UpdateBudget(this._repo);

  Future<Budget> call({
    required int budgetId,
    double? amount,
    int? categoryId,
    int? month,
  }) {
    return _repo.updateBudget(
      budgetId: budgetId,
      amount: amount,
      categoryId: categoryId,
      month: month,
    );
  }
}
