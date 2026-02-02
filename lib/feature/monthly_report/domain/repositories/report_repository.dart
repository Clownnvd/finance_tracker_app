import '../entities/category_total.dart';
import '../entities/month_total.dart';
import '../entities/top_expense.dart';
import '../value_objects/money.dart';
import '../value_objects/report_month.dart';

/// Domain contract for Monthly Report.
///
/// Notes:
/// - Domain depends on this interface only (not on DTOs / Dio / Supabase).
/// - Data layer will implement this interface and handle mapping/errors.
abstract class MonthlyReportRepository {
  /// Returns totals for the whole year by type (INCOME/EXPENSE).
  ///
  /// Used by Monthly trend (line chart).
  Future<List<MonthTotal>> getYearTotals({
    required int year,
    required MonthTotalType type,
  });

  /// Returns the total of a specific month by type.
  ///
  /// Used by Monthly cards & Summary.
  Future<Money> getMonthTotal({
    required ReportMonth month,
    required MonthTotalType type,
  });

  /// Returns category breakdown for a given month and type.
  ///
  /// Used by Category tab (pie charts).
  Future<List<CategoryTotal>> getCategoryTotals({
    required ReportMonth month,
    required MonthTotalType type,
  });

  /// Returns top expenses for a given month.
  ///
  /// Used by Summary tab.
  Future<List<TopExpense>> getTopExpenses({
    required ReportMonth month,
    int limit = 3,
  });
}
