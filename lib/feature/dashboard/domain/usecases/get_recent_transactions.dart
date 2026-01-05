import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/repositories/dashboard_repository.dart';

class GetRecentTransactions {
  final DashboardRepository _repo;

  const GetRecentTransactions(this._repo);

  Future<List<DashboardTransaction>> call({
    int limit = 20,
  }) {
    return _repo.getRecentTransactions(limit: limit);
  }
}
