import 'package:equatable/equatable.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';

class DashboardState extends Equatable {
  final bool isLoading;
  final String? error;
  final DateTime month;
  final DashboardSummary summary;
  final List<Map<String, dynamic>> expenseBreakdown;
  final List<Map<String, dynamic>> incomeBreakdown;
  final List<DashboardTransaction> recent;

  const DashboardState({
    required this.isLoading,
    required this.month,
    required this.summary,
    required this.expenseBreakdown,
    required this.incomeBreakdown,
    required this.recent,
    this.error,
  });

  factory DashboardState.initial() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    return DashboardState(
      isLoading: false,
      month: monthStart,
      summary: const DashboardSummary(income: 0, expenses: 0),
      expenseBreakdown: const [],
      incomeBreakdown: const [],
      recent: const [],
    );
  }

  double get balance => summary.balance;

  DashboardState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    DateTime? month,
    DashboardSummary? summary,
    List<Map<String, dynamic>>? expenseBreakdown,
    List<Map<String, dynamic>>? incomeBreakdown,
    List<DashboardTransaction>? recent,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      month: month ?? this.month,
      summary: summary ?? this.summary,
      expenseBreakdown: expenseBreakdown ?? this.expenseBreakdown,
      incomeBreakdown: incomeBreakdown ?? this.incomeBreakdown,
      recent: recent ?? this.recent,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        month,
        summary.income,
        summary.expenses,
        expenseBreakdown,
        incomeBreakdown,
        recent,
      ];
}
