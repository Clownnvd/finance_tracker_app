// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardSummaryModel _$DashboardSummaryModelFromJson(
  Map<String, dynamic> json,
) => _DashboardSummaryModel(
  income: (json['income'] as num).toDouble(),
  expenses: (json['expenses'] as num).toDouble(),
);

Map<String, dynamic> _$DashboardSummaryModelToJson(
  _DashboardSummaryModel instance,
) => <String, dynamic>{
  'income': instance.income,
  'expenses': instance.expenses,
};

_DashboardTransactionModel _$DashboardTransactionModelFromJson(
  Map<String, dynamic> json,
) => _DashboardTransactionModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  icon: json['icon'] as String,
  date: DateTime.parse(json['date'] as String),
  amount: (json['amount'] as num).toDouble(),
  isIncome: json['isIncome'] as bool,
  note: json['note'] as String?,
  categoryId: (json['categoryId'] as num?)?.toInt(),
);

Map<String, dynamic> _$DashboardTransactionModelToJson(
  _DashboardTransactionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'icon': instance.icon,
  'date': instance.date.toIso8601String(),
  'amount': instance.amount,
  'isIncome': instance.isIncome,
  'note': instance.note,
  'categoryId': instance.categoryId,
};

_DashboardCategoryBreakdownModel _$DashboardCategoryBreakdownModelFromJson(
  Map<String, dynamic> json,
) => _DashboardCategoryBreakdownModel(
  categoryId: (json['category_id'] as num).toInt(),
  name: json['name'] as String,
  total: (json['total'] as num).toDouble(),
  percent: (json['percent'] as num).toDouble(),
);

Map<String, dynamic> _$DashboardCategoryBreakdownModelToJson(
  _DashboardCategoryBreakdownModel instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'name': instance.name,
  'total': instance.total,
  'percent': instance.percent,
};
