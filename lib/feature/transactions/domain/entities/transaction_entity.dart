import 'category_entity.dart';

class TransactionEntity {
  final int? id;
  final String userId;
  final int categoryId;
  final TransactionType type; // INCOME/EXPENSE
  final double amount;
  final DateTime date;
  final String? note;

  const TransactionEntity({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.type,
    required this.amount,
    required this.date,
    this.note,
  });
}
