// lib/feature/transactions/presentation/transaction_history/widgets/history_section_header.dart
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';

import '../../../feature/transactions/presentation/transaction_history/helpers/history_formatters.dart';

class HistorySectionHeader extends StatelessWidget {
  final String title;

  /// Totals are optional (if you want only title, pass null or hideTotals=true)
  final double? incomeTotal;
  final double? expenseTotal;

  /// If true, only show the title row.
  final bool hideTotals;

  /// Optional currency symbol shown by formatter (e.g. "₫")
  final String? currencySymbol;

  const HistorySectionHeader({
    super.key,
    required this.title,
    this.incomeTotal,
    this.expenseTotal,
    this.hideTotals = false,
    this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final income = incomeTotal ?? 0;
    final expense = expenseTotal ?? 0;

    final incomeText = HistoryFormatters.formatMoney(
      income,
      type: TransactionType.income,
      currencySymbol: currencySymbol,
      showSign: true,
    );

    final expenseText = HistoryFormatters.formatMoney(
      expense,
      type: TransactionType.expense,
      currencySymbol: currencySymbol,
      showSign: true,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Title
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          if (!hideTotals) ...[
            _Pill(
              text: incomeText,
              icon: Icons.arrow_downward_rounded,
              background: theme.colorScheme.primary.withOpacity(0.10),
              foreground: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            _Pill(
              text: expenseText,
              icon: Icons.arrow_upward_rounded,
              background: theme.colorScheme.error.withOpacity(0.10),
              foreground: theme.colorScheme.error,
            ),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color background;
  final Color foreground;

  const _Pill({
    required this.text,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: foreground.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 6),
          Text(
            text,
            style: theme.textTheme.labelMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
