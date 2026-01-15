import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardData {
  final DashboardRepository _repo;

  const GetDashboardData(this._repo);

  Future<DashboardData> call({
    required DateTime month,
    int recentLimit = 3,
  }) {
    return _repo.getDashboardData(
      month: month,
      recentLimit: recentLimit,
    );
  }
}
