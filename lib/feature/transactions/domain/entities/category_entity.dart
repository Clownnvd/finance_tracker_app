enum TransactionType { income, expense }

extension TransactionTypeX on TransactionType {
  String get apiValue {
    switch (this) {
      case TransactionType.income:
        return 'INCOME';
      case TransactionType.expense:
        return 'EXPENSE';
    }
  }

  static TransactionType fromApi(String v) {
    final x = v.trim().toUpperCase();
    if (x == 'INCOME') return TransactionType.income;
    return TransactionType.expense;
  }
}

class CategoryEntity {
  final int id;
  final String name;
  final TransactionType type;
  final String icon; // keep string to map to UI icons later

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
  });
}
