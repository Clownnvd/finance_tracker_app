import 'package:finance_tracker_app/feature/monthly_report/domain/repositories/report_repository.dart';

import '../entities/monthly_trend.dart';
import '../entities/month_total.dart';
import '../value_objects/money.dart';
import '../value_objects/report_month.dart';

/// Builds MonthlyTrend for a given year.
///
/// Responsibilities:
/// - Fetch yearly income/expense totals.
/// - Fill missing months with Money.zero.
/// - Provide a stable structure for chart rendering.
class GetMonthlyTrend {
  final MonthlyReportRepository _repo;

  const GetMonthlyTrend(this._repo);

  Future<MonthlyTrend> call({
    required int year,
    required ReportMonth selectedMonth,
  }) async {
    // Fetch yearly totals for both series.
    final incomeTotals = await _repo.getYearTotals(
      year: year,
      type: MonthTotalType.income,
    );

    final expenseTotals = await _repo.getYearTotals(
      year: year,
      type: MonthTotalType.expense,
    );

    // Build maps with default 0 for missing months.
    final incomeByMonth = <ReportMonth, Money>{};
    final expenseByMonth = <ReportMonth, Money>{};

    // Pre-fill all 12 months so UI/Chart never deals with null.
    for (var m = 1; m <= 12; m++) {
      final rm = ReportMonth(year: year, month: m);
      incomeByMonth[rm] = Money.zero;
      expenseByMonth[rm] = Money.zero;
    }

    // Apply data from backend.
    for (final it in incomeTotals) {
      incomeByMonth[it.month] = it.amount;
    }
    for (final it in expenseTotals) {
      expenseByMonth[it.month] = it.amount;
    }

    return MonthlyTrend(
      year: year,
      incomeByMonth: incomeByMonth,
      expenseByMonth: expenseByMonth,
      selectedMonth: selectedMonth,
    );
  }
}
