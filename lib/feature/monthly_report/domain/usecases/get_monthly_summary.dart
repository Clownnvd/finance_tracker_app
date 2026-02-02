import 'package:finance_tracker_app/feature/monthly_report/domain/repositories/report_repository.dart';

import '../entities/monthly_summary.dart';
import '../entities/month_total.dart';
import '../value_objects/report_month.dart';

/// Builds MonthlySummary for a selected month.
///
/// Responsibilities:
/// - Fetch income & expense totals for the month.
/// - Fetch top expenses.
/// - Calculate balance in a single place (not in Cubit/UI).
class GetMonthlySummary {
  final MonthlyReportRepository _repo;

  const GetMonthlySummary(this._repo);

  Future<MonthlySummary> call({
    required ReportMonth month,
    int topLimit = 3,
  }) async {
    final income = await _repo.getMonthTotal(
      month: month,
      type: MonthTotalType.income,
    );

    final expense = await _repo.getMonthTotal(
      month: month,
      type: MonthTotalType.expense,
    );

    final topExpenses = await _repo.getTopExpenses(
      month: month,
      limit: topLimit,
    );

    return MonthlySummary.fromIncomeExpense(
      month: month,
      income: income,
      expense: expense,
      topExpenses: topExpenses,
    );
  }
}
