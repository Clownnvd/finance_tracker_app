// lib/feature/transactions/presentation/transaction_history/widgets/history_item_tile.dart
import 'package:flutter/material.dart';

import '../../../feature/transactions/domain/entities/category_entity.dart';
import '../../../feature/transactions/domain/entities/transaction_entity.dart';
import '../../../feature/transactions/presentation/transaction_history/helpers/history_formatters.dart';

class HistoryItemTile extends StatelessWidget {
  final TransactionEntity tx;

  final String categoryName;

  /// REAL icon for UI (IconData)
  final IconData icon;

  final String? currencySymbol;

  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HistoryItemTile({
    super.key,
    required this.tx,
    required this.categoryName,
    required this.icon,
    this.currencySymbol,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final amountText = HistoryFormatters.formatMoney(
      tx.amount,
      type: tx.type,
      currencySymbol: currencySymbol,
      showSign: true,
    );

    final dateText = HistoryFormatters.formatDateShort(tx.date);
    final note = HistoryFormatters.safeNote(tx.note);

    final amountColor = switch (tx.type) {
      TransactionType.income => theme.colorScheme.primary,
      TransactionType.expense => theme.colorScheme.error,
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.dividerColor.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            _IconBox(icon: icon),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    HistoryFormatters.safeCategoryName(categoryName),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    note == null ? dateText : '$dateText • $note',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.70),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Text(
              amountText,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;

  const _IconBox({required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.60),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.25)),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 20,
        color: theme.colorScheme.onSurface.withOpacity(0.80),
      ),
    );
  }
}
