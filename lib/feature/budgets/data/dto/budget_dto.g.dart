// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BudgetDto _$BudgetDtoFromJson(Map<String, dynamic> json) => _BudgetDto(
  id: (json['id'] as num).toInt(),
  userId: json['user_id'] as String,
  categoryId: (json['category_id'] as num).toInt(),
  amount: (json['amount'] as num).toDouble(),
  month: (json['month'] as num).toInt(),
);

Map<String, dynamic> _$BudgetDtoToJson(_BudgetDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'category_id': instance.categoryId,
      'amount': instance.amount,
      'month': instance.month,
    };
