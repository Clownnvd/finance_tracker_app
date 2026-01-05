enum DashboardType { income, expense }

extension DashboardTypeX on DashboardType {
  String get apiValue {
    switch (this) {
      case DashboardType.income:
        return 'INCOME';
      case DashboardType.expense:
        return 'EXPENSE';
    }
  }
}

class DashboardSummary {
  final double income;
  final double expenses;

  const DashboardSummary({
    required this.income,
    required this.expenses,
  });

  double get balance => income - expenses;
}

class DashboardTransaction {
  final int id;
  final String title;
  final String icon;
  final DateTime date;
  final double amount;
  final bool isIncome;
  final String? note;
  final int? categoryId;

  const DashboardTransaction({
    required this.id,
    required this.title,
    required this.icon,
    required this.date,
    required this.amount,
    required this.isIncome,
    this.note,
    this.categoryId,
  });
}
