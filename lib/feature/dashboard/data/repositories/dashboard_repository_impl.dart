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
  Future<DashboardSummary> getSummaryForMonth(DateTime month) async {
    final model = await _remote.fetchSummaryForMonth(month);
    return model.toEntity();
  }

  @override
  Future<List<DashboardTransaction>> getRecentTransactions({int limit = 20}) async {
    final models = await _remote.fetchRecentTransactions(limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<DashboardTransaction>> getRecentTransactionsForMonth({
    required DateTime month,
    int limit = 20,
  }) async {
    final models = await _remote.fetchRecentTransactionsForMonth(
      month: month,
      limit: limit,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getCategoryBreakdownForMonth({
    required DateTime month,
    required String type,
  }) async {
    final uid = await _userIdLocal.getUserId();
    if (uid == null || uid.isEmpty) {
      throw Exception('Missing user_id');
    }

    return _remote.fetchCategoryBreakdownForMonth(
      uid: uid,
      month: month,
      type: type,
    );
  }
}
