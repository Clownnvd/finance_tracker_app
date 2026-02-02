import 'package:finance_tracker_app/feature/budgets/domain/entities/budget.dart';
import 'package:finance_tracker_app/feature/budgets/domain/repositories/budgets_repository.dart';

class GetAllBudgets {
  final BudgetsRepository _repo;
  const GetAllBudgets(this._repo);

  Future<List<Budget>> call() => _repo.getMyBudgets();
}
