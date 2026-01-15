// lib/feature/transactions/presentation/transaction_history/helpers/history_grouping.dart
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/transaction_entity.dart';
import 'history_formatters.dart';

/// A UI-friendly grouped section for Transaction History.
class HistorySection {
  final DateTime dateKey; // date-only (local)
  final String title; // Today / Yesterday / Apr 27, 2024
  final List<TransactionEntity> items;

  final double incomeTotal;
  final double expenseTotal;

  const HistorySection({
    required this.dateKey,
    required this.title,
    required this.items,
    required this.incomeTotal,
    required this.expenseTotal,
  });

  double get net => incomeTotal - expenseTotal;
}

/// Pure grouping utilities (no Flutter, no IO).
class HistoryGrouping {
  HistoryGrouping._();

  /// Groups transactions by local date (YYYY-MM-DD), newest section first.
  ///
  /// Assumptions:
  /// - Input items may already be sorted by API (date desc, id desc),
  ///   but this function defensively sorts within each section too.
  static List<HistorySection> groupByDay(List<TransactionEntity> items) {
    if (items.isEmpty) return const <HistorySection>[];

    // Map<DateKey, List<Item>>
    final Map<DateTime, List<TransactionEntity>> buckets = {};

    for (final tx in items) {
      final key = HistoryFormatters.dateOnly(tx.date);
      (buckets[key] ??= <TransactionEntity>[]).add(tx);
    }

    // Sort section keys newest first
    final keys = buckets.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    final sections = <HistorySection>[];

    for (final key in keys) {
      final bucketItems = buckets[key] ?? const <TransactionEntity>[];

      // Sort items newest first (date desc, then id desc if present)
      final sorted = List<TransactionEntity>.from(bucketItems)
        ..sort((a, b) {
          final d = b.date.compareTo(a.date);
          if (d != 0) return d;

          final ai = a.id ?? -1;
          final bi = b.id ?? -1;
          return bi.compareTo(ai);
        });

      double income = 0;
      double expense = 0;

      for (final tx in sorted) {
        final amt = tx.amount;
        if (amt.isNaN || amt.isInfinite) continue;

        switch (tx.type) {
          case TransactionType.income:
            income += amt.abs();
            break;
          case TransactionType.expense:
            expense += amt.abs();
            break;
        }
      }

      sections.add(
        HistorySection(
          dateKey: key,
          title: HistoryFormatters.formatSectionLabel(key),
          items: List.unmodifiable(sorted),
          incomeTotal: income,
          expenseTotal: expense,
        ),
      );
    }

    return List.unmodifiable(sections);
  }
}
