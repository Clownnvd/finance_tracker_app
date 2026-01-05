import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/usecases/get_category_breakdown.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/usecases/get_dashboard_summary.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/usecases/get_recent_transactions.dart';

import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardSummary _getDashboardSummary;
  final GetCategoryBreakdown _getCategoryBreakdown;
  final GetRecentTransactions _getRecentTransactions;

  DashboardCubit({
    required GetDashboardSummary getDashboardSummary,
    required GetCategoryBreakdown getCategoryBreakdown,
    required GetRecentTransactions getRecentTransactions,
  })  : _getDashboardSummary = getDashboardSummary,
        _getCategoryBreakdown = getCategoryBreakdown,
        _getRecentTransactions = getRecentTransactions,
        super(DashboardState.initial());

  DateTime _normalizeMonth(DateTime d) => DateTime(d.year, d.month, 1);

  Future<void> load({
    DateTime? month,
    int recentLimit = 3,
    bool force = false,
  }) async {
    if (state.isLoading && !force) return;

    final m = _normalizeMonth(month ?? state.month);
    emit(state.copyWith(isLoading: true, month: m, clearError: true));

    try {
      final summary = await _getDashboardSummary(month: m);

      final expenseBreakdown = await _getCategoryBreakdown(
        month: m,
        type: DashboardType.expense,
      );

      final incomeBreakdown = await _getCategoryBreakdown(
        month: m,
        type: DashboardType.income,
      );

      final recent = await _getRecentTransactions(limit: recentLimit);

      emit(state.copyWith(
        isLoading: false,
        clearError: true,
        summary: summary,
        expenseBreakdown: expenseBreakdown,
        incomeBreakdown: incomeBreakdown,
        recent: recent,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> refresh({int recentLimit = 3}) async {
    await load(month: state.month, recentLimit: recentLimit, force: true);
  }

  Future<void> setMonth(DateTime month, {int recentLimit = 3}) async {
    await load(month: month, recentLimit: recentLimit);
  }

  Future<void> prevMonth({int recentLimit = 3}) async {
    final prev = DateTime(state.month.year, state.month.month - 1, 1);
    await load(month: prev, recentLimit: recentLimit);
  }

  Future<void> nextMonth({int recentLimit = 3}) async {
    final next = DateTime(state.month.year, state.month.month + 1, 1);
    await load(month: next, recentLimit: recentLimit);
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }
}
