import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_models.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../models/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remote;

  DashboardRepositoryImpl(this.remote);

  @override
  Future<(DashboardSummaryModel, List<DashboardTransactionModel>)> getDashboard() async {
    final totalsRaw = await remote.fetchMonthTotals(DateTime.now());
    final txRaw = await remote.fetchRecentTransactions();

    final summaryModel =
        DashboardSummaryModel.fromMonthTotals(totalsRaw);

    final transactions = txRaw
        .map(DashboardTransactionModel.fromJson)
        .map(
          (m) => DashboardTransactionModel(
            title: m.title,
            icon: m.icon,
            date: m.date,
            amount: m.amount,
            isIncome: m.isIncome,
          ),
        )
        .toList();

    final summary = DashboardSummaryModel(
      income: summaryModel.income,
      expenses: summaryModel.expenses,
    );

    return (summary, transactions);
  }
}
