import 'package:finance_tracker_app/feature/monthly_report/domain/repositories/report_repository.dart';

import '../entities/category_total.dart';
import '../entities/month_total.dart';
import '../value_objects/report_month.dart';

/// Fetches category breakdown for a month and a type.
///
/// Used by Category tab:
/// - EXPENSE pie chart
/// - INCOME pie chart
class GetCategoryBreakdown {
  final MonthlyReportRepository _repo;

  const GetCategoryBreakdown(this._repo);

  Future<List<CategoryTotal>> call({
    required ReportMonth month,
    required MonthTotalType type,
  }) {
    return _repo.getCategoryTotals(month: month, type: type);
  }
}
