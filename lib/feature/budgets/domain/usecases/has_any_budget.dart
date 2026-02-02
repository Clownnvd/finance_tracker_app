import '../repositories/budgets_repository.dart';

class HasAnyBudget {
  final BudgetsRepository _repo;
  const HasAnyBudget(this._repo);

  Future<bool> call() => _repo.hasAnyBudget();
}
