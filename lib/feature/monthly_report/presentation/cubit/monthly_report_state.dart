import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/category_total.dart';
import '../../domain/entities/monthly_summary.dart';
import '../../domain/entities/monthly_trend.dart';
import '../../domain/value_objects/report_month.dart';

part 'monthly_report_state.freezed.dart';

enum MonthlyReportTab { monthly, category, summary }

@freezed
abstract class MonthlyReportState with _$MonthlyReportState {
  const factory MonthlyReportState({
    @Default(MonthlyReportTab.monthly) MonthlyReportTab tab,

    /// Month currently selected by dropdown (drives Summary + Category)
    required ReportMonth selectedMonth,

    /// Year trend series (12 months)
    MonthlyTrend? trend,

    /// Summary of selected month (income/expense/balance + top expenses)
    MonthlySummary? summary,

    /// Category breakdown of selected month
    @Default(<CategoryTotal>[]) List<CategoryTotal> expenseCategories,
    @Default(<CategoryTotal>[]) List<CategoryTotal> incomeCategories,

    /// Loading flags
    @Default(false) bool isLoadingTrend,
    @Default(false) bool isLoadingMonthData,

    /// Error surface for UI
    String? errorMessage,
  }) = _MonthlyReportState;

  const MonthlyReportState._();
  bool get isLoading => isLoadingTrend || isLoadingMonthData;


  bool get hasError => (errorMessage ?? '').trim().isNotEmpty;
}
