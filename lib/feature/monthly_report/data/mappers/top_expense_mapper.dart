import 'package:finance_tracker_app/feature/monthly_report/data/dto/top_expense_dto.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/entities/top_expense.dart';
import 'package:finance_tracker_app/feature/monthly_report/domain/value_objects/money.dart';


/// Maps TopExpenseDto (transaction row with embedded category) -> TopExpense (domain).
class TopExpenseMapper {
  const TopExpenseMapper._();

  static TopExpense toDomain(TopExpenseDto dto) {
    // Domain requires categoryName, but backend join may return null
    // if relation is missing. Use a safe fallback.
    final safeName = (dto.categoryName == null || dto.categoryName!.trim().isEmpty)
        ? 'Unknown'
        : dto.categoryName!.trim();

    return TopExpense(
      transactionId: dto.id,
      categoryId: dto.categoryId,
      categoryName: safeName,
      categoryIcon: dto.categoryIcon,
      amount: Money(dto.amount),
    );
  }

  static List<TopExpense> toDomainList(List<TopExpenseDto> dtos) {
    return dtos.map(toDomain).toList();
  }
}
