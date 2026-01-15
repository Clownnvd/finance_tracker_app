// lib/feature/transactions/presentation/transaction_history/helpers/history_formatters.dart
import 'package:intl/intl.dart';

import '../../../domain/entities/category_entity.dart';

/// Pure formatting helpers for Transaction History UI.
///
/// Notes:
/// - Do NOT put colors here.
/// - Keep everything deterministic & testable.
/// - Use local time for date formatting.
class HistoryFormatters {
  HistoryFormatters._();

  static final NumberFormat _moneyFmt = NumberFormat.decimalPattern(); // 1,234,567
  static final DateFormat _dateShortFmt = DateFormat.yMMMd(); // Apr 27, 2024

  /// Formats amount with sign based on [type].
  ///
  /// Examples:
  /// - INCOME: +1,200,000
  /// - EXPENSE: -80,000
  static String formatMoney(
    double amount, {
    required TransactionType type,
    String? currencySymbol, // optional: ₫ / $ / etc
    bool showSign = true,
  }) {
    if (amount.isNaN || amount.isInfinite) return '--';

    final abs = amount.abs();
    final formatted = _moneyFmt.format(abs);

    final sign = switch (type) {
      TransactionType.income => '+',
      TransactionType.expense => '-',
    };

    final withSign = showSign ? '$sign$formatted' : formatted;
    if (currencySymbol == null || currencySymbol.trim().isEmpty) return withSign;

    // Currency at end to match many VN UIs: 1,200,000 ₫
    return '$withSign ${currencySymbol.trim()}';
  }

  /// Short date like "Apr 27, 2024".
  static String formatDateShort(DateTime d) {
    final local = d.toLocal();
    return _dateShortFmt.format(local);
  }

  /// Date-only key (00:00 local) used for grouping.
  static DateTime dateOnly(DateTime d) {
    final local = d.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  /// Section title:
  /// - Today / Yesterday / otherwise date short.
  static String formatSectionLabel(DateTime dateKey) {
    final key = dateOnly(dateKey);
    final nowKey = dateOnly(DateTime.now());
    final yesterdayKey = nowKey.subtract(const Duration(days: 1));

    if (key == nowKey) return 'Today';
    if (key == yesterdayKey) return 'Yesterday';
    return formatDateShort(key);
  }

  /// Returns a clean note or null if empty.
  static String? safeNote(String? note) {
    final n = (note ?? '').trim();
    return n.isEmpty ? null : n;
  }

  /// Safe category name fallback.
  static String safeCategoryName(String? name) {
    final x = (name ?? '').trim();
    return x.isEmpty ? 'Unknown' : x;
  }
}
