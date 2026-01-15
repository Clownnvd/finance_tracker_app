import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_models.dart';

extension DashboardSummaryModelX on DashboardSummaryModel {
  DashboardSummary toEntity() => DashboardSummary(
        income: income,
        expenses: expenses,
      );
}

extension DashboardTransactionModelX on DashboardTransactionModel {
  DashboardTransaction toEntity() => DashboardTransaction(
        id: id,
        title: title,
        icon: icon,
        date: date,
        amount: amount,
        isIncome: isIncome,
        note: note,
        categoryId: categoryId,
      );
}

extension DashboardCategoryBreakdownModelX on DashboardCategoryBreakdownModel {
  DashboardCategoryBreakdownItem toEntity() => DashboardCategoryBreakdownItem(
        categoryId: categoryId,
        name: name,
        total: total,
        percent: percent,
      );
}
