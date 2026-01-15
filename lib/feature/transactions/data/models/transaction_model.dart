import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

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

String _toStr(dynamic v) => (v ?? '').toString();

DateTime _toDate(dynamic v) {
  final s = _toStr(v);
  return DateTime.tryParse(s) ?? DateTime.fromMillisecondsSinceEpoch(0);
}

String _dateOnly(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    int? id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'category_id') required int categoryId,
    required String type, // "INCOME" | "EXPENSE" (API string)
    required double amount,
    String? note,
    required DateTime date,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  /// Builds a model from PostgREST/Supabase API response.
  factory TransactionModel.fromApi(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] == null ? null : _toInt(json['id']),
      userId: _toStr(json['user_id']),
      categoryId: _toInt(json['category_id']),
      type: _toStr(json['type']).toUpperCase(),
      amount: _toDouble(json['amount']),
      note: json['note']?.toString(),
      date: _toDate(json['date']),
    );
  }
}

extension TransactionModelX on TransactionModel {
  /// Converts model to domain entity.
  TransactionEntity toEntity() => TransactionEntity(
        id: id,
        userId: userId,
        categoryId: categoryId,
        type: TransactionTypeX.fromApi(type),
        amount: amount,
        date: date,
        note: note,
      );

  /// Converts domain entity to model.
  static TransactionModel fromEntity(TransactionEntity e) => TransactionModel(
        id: e.id,
        userId: e.userId,
        categoryId: e.categoryId,
        type: e.type.apiValue,
        amount: e.amount,
        note: e.note,
        date: e.date,
      );

  /// Payload for PostgREST INSERT.
  ///
  /// Notes:
  /// - Keep keys aligned with table columns.
  /// - Store date as YYYY-MM-DD (no time).
  Map<String, dynamic> toInsertJson() => {
        'user_id': userId,
        'category_id': categoryId,
        'type': type,
        'amount': amount,
        'note': note,
        'date': _dateOnly(date),
      };
}
