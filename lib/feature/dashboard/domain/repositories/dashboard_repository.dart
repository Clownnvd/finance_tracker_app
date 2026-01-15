import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';

abstract class DashboardRepository {
  Future<DashboardData> getDashboardData({
    required DateTime month,
    int recentLimit,
  });
}
