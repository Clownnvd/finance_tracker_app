

import 'package:finance_tracker_app/feature/monthly_report/data/dto/category_total_dto.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/category_total.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/money.dart';

/// Maps CategoryTotalDto (RPC result) -> CategoryTotal (domain).
///
/// Note:
/// - RPC currently returns (category_id, name, total, percent).
/// - Icon is not returned by RPC, so `icon` is set to null.
///   If later you need icon, you can:
///   - Update RPC to return icon, or
///   - Join categories table via a separate call and merge in repository.
class CategoryTotalMapper {
  const CategoryTotalMapper._();

  static CategoryTotal toDomain(CategoryTotalDto dto) {
    return CategoryTotal(
      categoryId: dto.categoryId,
      name: dto.name,
      icon: null,
      total: Money(dto.total),
      percent: dto.percent,
    );
  }

  static List<CategoryTotal> toDomainList(List<CategoryTotalDto> dtos) {
    return dtos.map(toDomain).toList();
  }
}
