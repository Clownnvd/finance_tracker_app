import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';
import 'package:finance_tracker_app/feature/dashboard/data/mappers/dashboard_mappers.dart';
import 'package:finance_tracker_app/feature/dashboard/data/models/dashboard_remote_data_source.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remote;
  final UserIdLocalDataSource _userIdLocal;

  DashboardRepositoryImpl({
    required DashboardRemoteDataSource remote,
    required UserIdLocalDataSource userIdLocal,
  })  : _remote = remote,
        _userIdLocal = userIdLocal;

  @override
  Future<DashboardData> getDashboardData({
    required DateTime month,
    int recentLimit = 3,
  }) async {
    final uid = await _userIdLocal.getUserId();
    if (uid == null || uid.isEmpty) {
      throw Exception('Missing user_id');
    }

    final summaryModel = await _remote.fetchSummaryForMonth(month);

    final expenseModels = await _remote.fetchCategoryBreakdownForMonth(
      uid: uid,
      month: month,
      type: DashboardType.expense.apiValue,
    );

    final incomeModels = await _remote.fetchCategoryBreakdownForMonth(
      uid: uid,
      month: month,
      type: DashboardType.income.apiValue,
    );

    final recentModels = await _remote.fetchRecentTransactionsForMonth(
      month: month,
      limit: recentLimit,
    );

    return DashboardData(
      month: DateTime(month.year, month.month, 1),
      summary: summaryModel.toEntity(),
      expenseBreakdown: expenseModels.map((e) => e.toEntity()).toList(),
      incomeBreakdown: incomeModels.map((e) => e.toEntity()).toList(),
      recent: recentModels.map((t) => t.toEntity()).toList(),
    );
  }
}
