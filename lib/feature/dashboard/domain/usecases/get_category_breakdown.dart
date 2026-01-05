import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/repositories/dashboard_repository.dart';

class GetCategoryBreakdown {
  final DashboardRepository _repo;

  const GetCategoryBreakdown(this._repo);

  Future<List<Map<String, dynamic>>> call({
    required DateTime month,
    required DashboardType type,
  }) {
    return _repo.getCategoryBreakdownForMonth(
      month: month,
      type: type.apiValue,
    );
  }
}
