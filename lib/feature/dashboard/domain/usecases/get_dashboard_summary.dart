import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardSummary {
  final DashboardRepository _repo;

  const GetDashboardSummary(this._repo);

  Future<DashboardSummary> call({
    required DateTime month,
  }) {
    return _repo.getSummaryForMonth(month);
  }
}
