import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_dto.freezed.dart';
part 'budget_dto.g.dart';

@freezed
abstract class BudgetDto with _$BudgetDto {
  const factory BudgetDto({
    required int id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'category_id') required int categoryId,
    required double amount,
    required int month,
  }) = _BudgetDto;

  factory BudgetDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetDtoFromJson(json);
}
