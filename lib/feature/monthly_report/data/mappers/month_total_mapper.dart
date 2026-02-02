import 'package:finance_tracker_app/feature/monthly_report/data/dto/month_total_dto.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/month_total.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/money.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/report_month.dart';

/// Maps MonthTotalDto (data layer) -> MonthTotal (domain).
class MonthTotalMapper {
  const MonthTotalMapper._();

  static MonthTotal toDomain(MonthTotalDto dto) {
    final month = ReportMonth(
      year: dto.month.year,
      month: dto.month.month,
    );

    return MonthTotal(
      month: month,
      amount: Money(dto.total),
      type: MonthTotalType.fromApi(dto.type),
    );
  }

  static List<MonthTotal> toDomainList(List<MonthTotalDto> dtos) {
    return dtos.map(toDomain).toList();
  }
}
