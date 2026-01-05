import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_models.freezed.dart';

@freezed
abstract class DashboardSummaryModel with _$DashboardSummaryModel {
  const factory DashboardSummaryModel({
    required double income,
    required double expenses,
  }) = _DashboardSummaryModel;

  factory DashboardSummaryModel.fromMonthTotals(List<dynamic> rows) {
    double income = 0;
    double expenses = 0;

    for (final r in rows) {
      final type = r['type'];
      final total = (r['total'] ?? 0).toDouble();

      if (type == 'INCOME') {
        income = total;
      } else if (type == 'EXPENSE') {
        expenses = total;
      }
    }

    return DashboardSummaryModel(
      income: income,
      expenses: expenses,
    );
  }
}

@freezed
abstract class DashboardTransactionModel with _$DashboardTransactionModel {
  const factory DashboardTransactionModel({
    required int id,
    required String title,
    required String icon,
    required DateTime date,
    required double amount,
    required bool isIncome,
    String? note,
    int? categoryId,
  }) = _DashboardTransactionModel;

  factory DashboardTransactionModel.fromJson(Map<String, dynamic> json) {
    final category = (json['categories'] as Map<String, dynamic>?) ?? {};

    return DashboardTransactionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (category['name'] ?? 'Unknown').toString(),
      icon: (category['icon'] ?? '').toString(),
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] ?? 0).toDouble(),
      isIncome: json['type'] == 'INCOME',
      note: json['note']?.toString(),
      categoryId: (json['category_id'] as num?)?.toInt(),
    );
  }
}
