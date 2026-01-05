import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';

abstract class DashboardRepository {
  Future<DashboardSummary> getSummaryForMonth(DateTime month);

  Future<List<DashboardTransaction>> getRecentTransactions({
    int limit,
  });

  Future<List<DashboardTransaction>> getRecentTransactionsForMonth({
    required DateTime month,
    int limit,
  });

  Future<List<Map<String, dynamic>>> getCategoryBreakdownForMonth({
    required DateTime month,
    required String type,
  });
}
