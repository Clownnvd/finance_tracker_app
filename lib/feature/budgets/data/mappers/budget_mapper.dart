import '../../domain/entities/budget.dart';
import '../dto/budget_dto.dart';

class BudgetMapper {
  const BudgetMapper._();

  static Budget toDomain(BudgetDto dto) {
    return Budget(
      id: dto.id,
      userId: dto.userId,
      categoryId: dto.categoryId,
      amount: dto.amount,
      month: dto.month,
    );
  }

  static List<Budget> toDomainList(List<BudgetDto> dtos) =>
      dtos.map(toDomain).toList();
}
