import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';
import 'package:finance_tracker_app/feature/dashboard/data/models/dashboard_remote_data_source.dart';
import 'package:finance_tracker_app/feature/dashboard/data/repositories/dashboard_repository_impl.dart';

class MockRemote extends Mock implements DashboardRemoteDataSource {}

class MockUserIdLocal extends Mock implements UserIdLocalDataSource {}

void main() {
  late MockRemote remote;
  late MockUserIdLocal userIdLocal;
  late DashboardRepositoryImpl repo;

  setUp(() {
    remote = MockRemote();
    userIdLocal = MockUserIdLocal();

    repo = DashboardRepositoryImpl(
      remote: remote,
      userIdLocal: userIdLocal,
    );
  });

  final month = DateTime(2026, 1, 1);

  test('getDashboardData aggregates all dashboard data', () async {
    when(() => userIdLocal.getUserId())
        .thenAnswer((_) async => 'user-1');

    when(() => remote.fetchSummaryForMonth(any()))
        .thenAnswer((_) async =>
            const DashboardSummaryModel(income: 1000, expenses: 300));

    when(() => remote.fetchCategoryBreakdownForMonth(
          uid: any(named: 'uid'),
          month: any(named: 'month'),
          type: any(named: 'type'),
        )).thenAnswer((_) async => []);

    when(() => remote.fetchRecentTransactionsForMonth(
          month: any(named: 'month'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => []);

    final result =
        await repo.getDashboardData(month: month, recentLimit: 3);

    expect(result.month, DateTime(2026, 1, 1));
    expect(result.summary.income, 1000);
    expect(result.summary.expenses, 300);

    verify(() => userIdLocal.getUserId()).called(1);
    verify(() => remote.fetchSummaryForMonth(month)).called(1);
  });
}
