class DashboardSummaryModel {
  final double income;
  final double expenses;

  const DashboardSummaryModel({
    required this.income,
    required this.expenses,
  });

  factory DashboardSummaryModel.fromMonthTotals(List<dynamic> rows) {
    double income = 0;
    double expenses = 0;

    for (final r in rows) {
      if (r['type'] == 'INCOME') {
        income = (r['total'] ?? 0).toDouble();
      } else if (r['type'] == 'EXPENSE') {
        expenses = (r['total'] ?? 0).toDouble();
      }
    }

    return DashboardSummaryModel(
      income: income,
      expenses: expenses,
    );
  }
}

class DashboardTransactionModel {
  final String title;
  final String icon;
  final DateTime date;
  final double amount;
  final bool isIncome;

  const DashboardTransactionModel({
    required this.title,
    required this.icon,
    required this.date,
    required this.amount,
    required this.isIncome,
  });

  factory DashboardTransactionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final category = json['categories'] as Map<String, dynamic>;

    return DashboardTransactionModel(
      title: category['name'],
      icon: category['icon'],
      date: DateTime.parse(json['date']),
      amount: (json['amount'] ?? 0).toDouble(),
      isIncome: json['type'] == 'INCOME',
    );
  }
}
