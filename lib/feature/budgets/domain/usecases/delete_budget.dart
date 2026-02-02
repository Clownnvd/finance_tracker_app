import '../repositories/budgets_repository.dart';

class DeleteBudget {
  final BudgetsRepository _repo;
  const DeleteBudget(this._repo);

  Future<void> call({required int budgetId}) => _repo.deleteBudget(budgetId: budgetId);
}
