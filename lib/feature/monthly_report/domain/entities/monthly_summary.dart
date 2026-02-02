import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/money.dart';
import '../value_objects/report_month.dart';
import 'top_expense.dart';

part 'monthly_summary.freezed.dart';

/// Aggregated summary for a specific month.
@freezed
abstract class MonthlySummary with _$MonthlySummary {
  const factory MonthlySummary({
    required ReportMonth month,
    required Money income,
    required Money expense,
    required Money balance,
    required List<TopExpense> topExpenses,
  }) = _MonthlySummary;

  /// Convenience factory to ensure balance is always correct.
  factory MonthlySummary.fromIncomeExpense({
    required ReportMonth month,
    required Money income,
    required Money expense,
    required List<TopExpense> topExpenses,
  }) {
    return MonthlySummary(
      month: month,
      income: income,
      expense: expense,
      balance: income - expense,
      topExpenses: topExpenses,
    );
  }
}
