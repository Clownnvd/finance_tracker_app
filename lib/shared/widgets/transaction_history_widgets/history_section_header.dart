// lib/feature/transactions/presentation/transaction_history/widgets/history_section_header.dart

import 'package:flutter/material.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';

class HistorySectionHeader extends StatelessWidget {
  final String title;

  /// Keep fields for compatibility, but UI in screenshot shows title only.
  final double? incomeTotal;
  final double? expenseTotal;
  final bool hideTotals;
  final String? currencySymbol;

  const HistorySectionHeader({
    super.key,
    required this.title,
    this.incomeTotal,
    this.expenseTotal,
    this.hideTotals = true, // screenshot: no totals pills
    this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: AppTextStyles.title.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.neutral900,
          ),
        ),
      ),
    );
  }
}
