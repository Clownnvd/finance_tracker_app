import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';

@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    required int id,
    required String userId,
    required int categoryId,
    required double amount,
    required int month, // 1..12
  }) = _Budget;
}
