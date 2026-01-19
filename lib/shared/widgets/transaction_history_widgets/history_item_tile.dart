// lib/feature/transactions/presentation/transaction_history/widgets/history_item_tile.dart

import 'package:flutter/material.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';

import '../../../feature/transactions/domain/entities/category_entity.dart';
import '../../../feature/transactions/domain/entities/transaction_entity.dart';
import '../../../feature/transactions/presentation/transaction_history/helpers/history_formatters.dart';

class HistoryItemTile extends StatelessWidget {
  final TransactionEntity tx;
  final String categoryName;

  /// IconData resolved outside (CategoryIconMapper)
  final IconData icon;

  /// Pass "$" to force USD style.
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

  static const Color _borderColor = AppColors.primaryLight;
  static const Color _titleBlue = AppColors.primaryDark;
  static const Color _incomeGreen = Color(0xFF16A34A);
  static const Color _salaryTeal = Color(0xFF2F9E9A);

  String _formatDateFull(DateTime d) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${m[d.month - 1]} ${d.day}, ${d.year}';
  }

  Color _amountColor(TransactionType type) {
    return switch (type) {
      TransactionType.income => _incomeGreen,
      TransactionType.expense => AppColors.error,
    };
  }

  Color _iconColorByCategoryName(String name) {
    final n = name.trim().toLowerCase();

    if (n.contains('food')) return AppColors.secondary;
    if (n.contains('shop')) return _titleBlue;
    if (n.contains('hous') || n.contains('home')) return AppColors.secondary;
    if (n.contains('salary')) return _salaryTeal;
    if (n.contains('free') || n.contains('work')) return AppColors.secondary;
    if (n.contains('invest')) return _titleBlue;
    if (n.contains('other')) return _titleBlue;

    return _titleBlue;
  }

  Color _iconColorFallbackByIcon(IconData iconData) {
    if (iconData == Icons.attach_money_rounded) return _salaryTeal;
    if (iconData == Icons.restaurant_rounded) return AppColors.secondary;
    if (iconData == Icons.home_rounded) return AppColors.secondary;
    if (iconData == Icons.shopping_bag_rounded) return _titleBlue;
    if (iconData == Icons.work_rounded) return AppColors.secondary;
    if (iconData == Icons.trending_up_rounded) return _titleBlue;
    if (iconData == Icons.groups_rounded) return _titleBlue;
    return _titleBlue;
  }

  Color _resolveIconColor() {
    final byName = _iconColorByCategoryName(categoryName);
    if (byName != _titleBlue) return byName;
    return _iconColorFallbackByIcon(icon);
  }

  /// Normalize money to: "$123.45"
  /// - Remove trailing symbol: "123 $" -> "123"
  /// - Remove spaces after prefix: "$ 123" -> "$123"
  /// - Ensure symbol is only at the beginning.
  String _normalizeCurrency(String formatted, String symbol) {
    final s = symbol.trim();
    if (s.isEmpty) return formatted.trim();

    var value = formatted.trim();

    // Remove trailing symbol (and any spaces before it).
    while (value.endsWith(s)) {
      value = value.substring(0, value.length - s.length).trimRight();
    }

    // Remove any spaces after prefix symbol.
    value = value.replaceAll('$s ', s);

    // Ensure exactly one prefix symbol.
    if (value.startsWith(s)) {
      // Also guard cases like "$$123"
      while (value.startsWith('$s$s')) {
        value = value.substring(s.length);
      }
      return value;
    }

    return '$s$value';
  }

  @override
  Widget build(BuildContext context) {
    final symbol = (currencySymbol ?? '\$').trim();

    var amountText = HistoryFormatters.formatMoney(
      tx.amount,
      type: tx.type,
      currencySymbol: symbol,
      showSign: false,
    );

    // Final output example: "$1200" or "$1,200.00" (no trailing "$", no space after "$")
    amountText = _normalizeCurrency(amountText, symbol);

    final dateText = _formatDateFull(tx.date);
    final amountColor = _amountColor(tx.type);
    final iconColor = _resolveIconColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.medium,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.medium,
            border: Border.all(color: _borderColor, width: 1.2),
            boxShadow: AppShadows.level1,
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  categoryName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyLg.copyWith(
                    color: _titleBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    amountText,
                    style: AppTextStyles.bodyLg.copyWith(
                      fontWeight: FontWeight.w800,
                      color: amountColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateText,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.neutral600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
