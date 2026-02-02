import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/month_total.dart';
import '../../domain/usecases/get_category_breakdown.dart';
import '../../domain/usecases/get_monthly_summary.dart';
import '../../domain/usecases/get_monthly_trend.dart';
import '../../domain/value_objects/report_month.dart';
import 'monthly_report_state.dart';

class MonthlyReportCubit extends Cubit<MonthlyReportState> {
  final GetMonthlyTrend _getMonthlyTrend;
  final GetMonthlySummary _getMonthlySummary;
  final GetCategoryBreakdown _getCategoryBreakdown;

  MonthlyReportCubit({
    required GetMonthlyTrend getMonthlyTrend,
    required GetMonthlySummary getMonthlySummary,
    required GetCategoryBreakdown getCategoryBreakdown,
  })  : _getMonthlyTrend = getMonthlyTrend,
        _getMonthlySummary = getMonthlySummary,
        _getCategoryBreakdown = getCategoryBreakdown,
        super(
          MonthlyReportState(
            selectedMonth: ReportMonth.fromDate(DateTime.now()),
          ),
        );

  // =========================
  // Lifecycle
  // =========================

  Future<void> init() async {
    await Future.wait([
      loadTrend(year: state.selectedMonth.year),
      loadMonthData(month: state.selectedMonth),
    ]);
  }

  // =========================
  // UI actions
  // =========================

  void changeTab(MonthlyReportTab tab) {
    if (tab == state.tab) return;
    emit(state.copyWith(tab: tab, errorMessage: null));
  }

  Future<void> changeMonth(ReportMonth month) async {
    if (month == state.selectedMonth) return;

    // Update selected month immediately so dropdown feels responsive
    emit(state.copyWith(selectedMonth: month, errorMessage: null));

    // If year changed => reload trend
    final currentTrendYear = state.trend?.year;
    if (currentTrendYear == null || currentTrendYear != month.year) {
      await loadTrend(year: month.year);
    } else {
      // If same year => only update selectedMonth inside trend (no refetch)
      final t = state.trend!;
      emit(state.copyWith(trend: t.copyWith(selectedMonth: month)));
    }

    // Reload month-specific data (summary + category)
    await loadMonthData(month: month);
  }

  // =========================
  // Data loading
  // =========================

  Future<void> loadTrend({required int year}) async {
    try {
      emit(state.copyWith(isLoadingTrend: true, errorMessage: null));

      // Keep selected month consistent with requested year
      final selected = state.selectedMonth.year == year
          ? state.selectedMonth
          : ReportMonth(year: year, month: 1);

      final trend = await _getMonthlyTrend(
        year: year,
        selectedMonth: selected,
      );

      // If we adjusted selected month to year=...month=1, reflect it to state too
      final updatedSelectedMonth =
          state.selectedMonth.year == year ? state.selectedMonth : selected;

      emit(
        state.copyWith(
          isLoadingTrend: false,
          trend: trend,
          selectedMonth: updatedSelectedMonth,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingTrend: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadMonthData({required ReportMonth month}) async {
    try {
      emit(state.copyWith(isLoadingMonthData: true, errorMessage: null));

      // Fetch in parallel for speed
      final results = await Future.wait([
        _getMonthlySummary(month: month, topLimit: 3),
        _getCategoryBreakdown(month: month, type: MonthTotalType.expense),
        _getCategoryBreakdown(month: month, type: MonthTotalType.income),
      ]);

      final summary = results[0] as dynamic; // MonthlySummary
      final expenseCats = results[1] as dynamic; // List<CategoryTotal>
      final incomeCats = results[2] as dynamic; // List<CategoryTotal>

      emit(
        state.copyWith(
          isLoadingMonthData: false,
          summary: summary,
          expenseCategories: expenseCats,
          incomeCategories: incomeCats,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingMonthData: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Optional: allow UI to clear banner/snackbar error state
  void clearError() {
    if (!state.hasError) return;
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> retry() async {
  await loadTrend(year: state.selectedMonth.year);
  await loadMonthData(month: state.selectedMonth);
} 
}