import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/money.dart';
import '../value_objects/report_month.dart';

part 'monthly_trend.freezed.dart';

/// Monthly trend data used by the "Monthly" tab (line chart).
///
/// - incomeByMonth & expenseByMonth must share the same month keys.
/// - Missing months should be filled with Money.zero by the usecase.
///
/// This entity is intentionally simple:
/// - No chart logic
/// - No UI concerns
/// - Only domain meaning
@freezed
abstract class MonthlyTrend with _$MonthlyTrend {
  const factory MonthlyTrend({
    required int year,

    /// Income totals grouped by month.
    required Map<ReportMonth, Money> incomeByMonth,

    /// Expense totals grouped by month.
    required Map<ReportMonth, Money> expenseByMonth,

    /// Currently selected month (for cards & dropdown).
    required ReportMonth selectedMonth,
  }) = _MonthlyTrend;

  const MonthlyTrend._();

  /// Derived helpers (safe to keep in entity).
  Money incomeOf(ReportMonth month) =>
      incomeByMonth[month] ?? Money.zero;

  Money expenseOf(ReportMonth month) =>
      expenseByMonth[month] ?? Money.zero;

  Money balanceOf(ReportMonth month) =>
      incomeOf(month) - expenseOf(month);
}
