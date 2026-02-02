import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/money.dart';

part 'top_expense.freezed.dart';

/// A single large expense item used in Monthly Summary.
@freezed
abstract class TopExpense with _$TopExpense {
  const factory TopExpense({
    required int transactionId,
    required int categoryId,
    required String categoryName,
    String? categoryIcon,
    required Money amount,
  }) = _TopExpense;
}
