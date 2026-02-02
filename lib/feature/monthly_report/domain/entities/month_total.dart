import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/money.dart';
import '../value_objects/report_month.dart';

part 'month_total.freezed.dart';

/// Total amount for a given month and type (income / expense).
@freezed
abstract class MonthTotal with _$MonthTotal {
  const factory MonthTotal({
    required ReportMonth month,
    required Money amount,
    required MonthTotalType type,
  }) = _MonthTotal;
}

/// Explicit enum for safety (avoid raw strings).
enum MonthTotalType {
  income,
  expense;

  static MonthTotalType fromApi(String raw) {
    switch (raw.toUpperCase()) {
      case 'INCOME':
        return MonthTotalType.income;
      case 'EXPENSE':
        return MonthTotalType.expense;
      default:
        throw ArgumentError('Unknown MonthTotalType: $raw');
    }
  }

  String toApi() {
    switch (this) {
      case MonthTotalType.income:
        return 'INCOME';
      case MonthTotalType.expense:
        return 'EXPENSE';
    }
  }
}
