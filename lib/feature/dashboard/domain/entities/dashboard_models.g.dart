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
