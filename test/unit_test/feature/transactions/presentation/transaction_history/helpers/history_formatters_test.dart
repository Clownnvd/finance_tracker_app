import 'package:flutter_test/flutter_test.dart';

import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/transaction_history/helpers/history_formatters.dart';

void main() {
  group('HistoryFormatters', () {
    test('formatMoney adds sign based on type', () {
      expect(
        HistoryFormatters.formatMoney(1200000, type: TransactionType.income),
        startsWith('+'),
      );
      expect(
        HistoryFormatters.formatMoney(80000, type: TransactionType.expense),
        startsWith('-'),
      );
    });

    test('formatMoney handles NaN/Infinity', () {
      expect(
        HistoryFormatters.formatMoney(double.nan, type: TransactionType.income),
        '--',
      );
      expect(
        HistoryFormatters.formatMoney(double.infinity, type: TransactionType.expense),
        '--',
      );
    });

    test('safeNote trims and nulls empty', () {
      expect(HistoryFormatters.safeNote('   '), isNull);
      expect(HistoryFormatters.safeNote(' hi '), 'hi');
      expect(HistoryFormatters.safeNote(null), isNull);
    });

    test('safeCategoryName fallback to Unknown', () {
      expect(HistoryFormatters.safeCategoryName('  '), 'Unknown');
      expect(HistoryFormatters.safeCategoryName(null), 'Unknown');
      expect(HistoryFormatters.safeCategoryName('Food'), 'Food');
    });

    test('dateOnly strips time (local)', () {
      final d = DateTime(2025, 1, 15, 23, 59, 59);
      final key = HistoryFormatters.dateOnly(d);
      expect(key.hour, 0);
      expect(key.minute, 0);
      expect(key.second, 0);
      expect(key.year, 2025);
      expect(key.month, 1);
      expect(key.day, 15);
    });
  });
}
