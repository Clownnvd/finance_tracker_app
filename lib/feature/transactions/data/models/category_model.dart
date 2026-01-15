import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

String _toStr(dynamic v) => (v ?? '').toString();

TransactionType _parseType(String raw) {
  final t = raw.trim().toUpperCase();
  if (t == 'INCOME') return TransactionType.income;
  return TransactionType.expense; // default safe fallback
}

@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required int id,
    required String name,
    required String type, // INCOME | EXPENSE
    required String icon,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  factory CategoryModel.fromApi(Map<String, dynamic> json) {
    return CategoryModel(
      id: _toInt(json['id']),
      name: _toStr(json['name']),
      type: _toStr(json['type']).toUpperCase(),
      icon: _toStr(json['icon']),
    );
  }
}

extension CategoryModelX on CategoryModel {
  CategoryEntity toEntity() => CategoryEntity(
        id: id,
        name: name,
        type: _parseType(type),
        icon: icon,
      );
}
