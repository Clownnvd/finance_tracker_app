import 'package:flutter_test/flutter_test.dart';

import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/helpers/history_grouping.dart';

TransactionEntity tx({
  int? id,
  required TransactionType type,
  required double amount,
  required DateTime date,
}) {
  return TransactionEntity(
    id: id,
    userId: 'u1',
    categoryId: 1,
    type: type,
    amount: amount,
    date: date,
    note: null,
  );
}

void main() {
  group('HistoryGrouping.groupByDay', () {
    test('returns empty when input empty', () {
      expect(HistoryGrouping.groupByDay(const []), isEmpty);
    });

    test('groups by local date and sorts sections newest first', () {
      final items = [
        tx(id: 1, type: TransactionType.expense, amount: 10, date: DateTime(2025, 1, 1, 12)),
        tx(id: 2, type: TransactionType.income, amount: 100, date: DateTime(2025, 1, 2, 9)),
        tx(id: 3, type: TransactionType.expense, amount: 5, date: DateTime(2025, 1, 2, 10)),
      ];

      final sections = HistoryGrouping.groupByDay(items);

      expect(sections.length, 2);
      expect(sections.first.dateKey, DateTime(2025, 1, 2));
      expect(sections.last.dateKey, DateTime(2025, 1, 1));
    });

    test('sorts items inside section by date desc then id desc', () {
      final items = [
        tx(id: 1, type: TransactionType.expense, amount: 10, date: DateTime(2025, 1, 2, 10)),
        tx(id: 2, type: TransactionType.expense, amount: 10, date: DateTime(2025, 1, 2, 10)),
        tx(id: 3, type: TransactionType.expense, amount: 10, date: DateTime(2025, 1, 2, 9)),
      ];

      final sections = HistoryGrouping.groupByDay(items);
      final list = sections.single.items;

      // same date/time => id desc
      expect(list[0].id, 2);
      expect(list[1].id, 1);
      expect(list[2].id, 3);
    });

    test('computes totals using abs; ignores NaN/Infinity', () {
      final items = [
        tx(id: 1, type: TransactionType.income, amount: -100, date: DateTime(2025, 1, 1, 10)),
        tx(id: 2, type: TransactionType.expense, amount: -40, date: DateTime(2025, 1, 1, 11)),
        tx(id: 3, type: TransactionType.income, amount: double.nan, date: DateTime(2025, 1, 1, 12)),
        tx(id: 4, type: TransactionType.expense, amount: double.infinity, date: DateTime(2025, 1, 1, 13)),
      ];

      final section = HistoryGrouping.groupByDay(items).single;
      expect(section.incomeTotal, 100);
      expect(section.expenseTotal, 40);
      expect(section.net, 60);
    });
  });
}
