import 'package:equatable/equatable.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';

class DashboardState extends Equatable {
  final bool isLoading;
  final String? error;
  final DateTime month;
  final DashboardData? data;

  const DashboardState({
    required this.isLoading,
    required this.month,
    this.data,
    this.error,
  });

  factory DashboardState.initial() {
    final now = DateTime.now();
    return DashboardState(
      isLoading: false,
      month: DateTime(now.year, now.month, 1),
    );
  }

  // ✅ ADD THESE GETTERS
  DashboardSummary get summary =>
      data?.summary ?? const DashboardSummary(income: 0, expenses: 0);

  List<DashboardTransaction> get recent =>
      data?.recent ?? const [];

  List<DashboardCategoryBreakdownItem> get expenseBreakdown =>
    data?.expenseBreakdown ?? const <DashboardCategoryBreakdownItem>[];

List<DashboardCategoryBreakdownItem> get incomeBreakdown =>
    data?.incomeBreakdown ?? const <DashboardCategoryBreakdownItem>[];


  double get balance => summary.income - summary.expenses;

  DashboardState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    DateTime? month,
    DashboardData? data,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      month: month ?? this.month,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, month, data];
}
