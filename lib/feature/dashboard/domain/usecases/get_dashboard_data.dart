
import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_models.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardData {
  final DashboardRepository repository;

  GetDashboardData(this.repository);

  Future<(DashboardSummaryModel, List<DashboardTransactionModel>)> call() {
    return repository.getDashboard();
  }
}
