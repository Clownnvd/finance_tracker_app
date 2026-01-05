import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_models.dart';

abstract class DashboardRepository {
  Future<(DashboardSummaryModel, List<DashboardTransactionModel>)> getDashboard();
}
