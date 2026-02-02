import '../entities/budget.dart';

abstract class BudgetsRepository {
  Future<List<Budget>> getMyBudgets();

  Future<Budget> createBudget({
    required int categoryId,
    required double amount,
    required int month,
  });

  Future<Budget> updateBudget({
    required int budgetId,
    double? amount,
    int? categoryId,
    int? month,
  });

  Future<void> deleteBudget({required int budgetId});

  /// phục vụ Settings: bật Budget Limit -> check có budget chưa
  Future<bool> hasAnyBudget();
}
