import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_models.freezed.dart';
part 'dashboard_models.g.dart';

double _toDouble(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

@freezed
abstract class DashboardSummaryModel with _$DashboardSummaryModel {
  const factory DashboardSummaryModel({
    required double income,
    required double expenses,
  }) = _DashboardSummaryModel;

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryModelFromJson(json);

  factory DashboardSummaryModel.fromMonthTotals(List<dynamic> rows) {
    double income = 0;
    double expenses = 0;

    for (final r in rows) {
      if (r is! Map) continue;
      final type = r['type']?.toString();
      final total = _toDouble(r['total']);

      if (type == 'INCOME') income = total;
      if (type == 'EXPENSE') expenses = total;
    }

    return DashboardSummaryModel(income: income, expenses: expenses);
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

  factory DashboardTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardTransactionModelFromJson(json);

  factory DashboardTransactionModel.fromApi(Map<String, dynamic> json) {
    final category = (json['categories'] as Map?)?.cast<String, dynamic>() ?? {};

    return DashboardTransactionModel(
      id: _toInt(json['id']),
      title: (category['name'] ?? 'Unknown').toString(),
      icon: (category['icon'] ?? '').toString(),
      date: DateTime.tryParse((json['date'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      amount: _toDouble(json['amount']),
      isIncome: (json['type'] ?? '').toString() == 'INCOME',
      note: json['note']?.toString(),
      categoryId: json['category_id'] == null ? null : _toInt(json['category_id']),
    );
  }
}

@freezed
abstract class DashboardCategoryBreakdownModel with _$DashboardCategoryBreakdownModel {
  const factory DashboardCategoryBreakdownModel({
    @JsonKey(name: 'category_id') required int categoryId,
    required String name,
    required double total,
    required double percent,
  }) = _DashboardCategoryBreakdownModel;

  factory DashboardCategoryBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardCategoryBreakdownModelFromJson(json);

  factory DashboardCategoryBreakdownModel.fromApi(Map<String, dynamic> json) {
    return DashboardCategoryBreakdownModel(
      categoryId: _toInt(json['category_id']),
      name: (json['name'] ?? '').toString(),
      total: _toDouble(json['total']),
      percent: _toDouble(json['percent']),
    );
  }
}
