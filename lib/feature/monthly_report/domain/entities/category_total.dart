import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/money.dart';

part 'category_total.freezed.dart';

/// Category breakdown item (for pie charts).
@freezed
abstract class CategoryTotal with _$CategoryTotal {
  const factory CategoryTotal({
    required int categoryId,
    required String name,
    String? icon,
    required Money total,

    /// Percentage value in range 0..100
    required double percent,
  }) = _CategoryTotal;
}
