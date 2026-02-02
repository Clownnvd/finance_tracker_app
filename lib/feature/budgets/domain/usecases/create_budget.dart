import '../entities/budget.dart';
import '../repositories/budgets_repository.dart';

class CreateBudget {
  final BudgetsRepository _repo;
  const CreateBudget(this._repo);

  Future<Budget> call({
    required int categoryId,
    required double amount,
    required int month,
  }) {
    return _repo.createBudget(categoryId: categoryId, amount: amount, month: month);
  }
}
