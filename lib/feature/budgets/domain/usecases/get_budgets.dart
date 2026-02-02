import '../entities/budget.dart';
import '../repositories/budgets_repository.dart';

class GetBudgets {
  final BudgetsRepository _repo;
  const GetBudgets(this._repo);

  Future<List<Budget>> call() => _repo.getMyBudgets();
}
