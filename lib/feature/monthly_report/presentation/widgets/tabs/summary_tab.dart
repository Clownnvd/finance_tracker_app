import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/monthly_summary.dart';
import '../../../domain/value_objects/money.dart';

import '../shared/report_card.dart';
import '../shared/month_pill.dart';
import '../shared/small_stat_card.dart';
import '../shared/top_expense_row.dart';

class SummaryTab extends StatelessWidget {
  final MonthlySummary? summary;
  const SummaryTab({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final s = summary;
    if (s == null) {
      return const ReportCard(child: Center(child: Text('No summary data')));
    }

    return ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Monthly Summary',
              style: AppTextStyles.title, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),

          Center(child: MonthPill(text: s.month.label)),
          const SizedBox(height: AppSpacing.md),

          Text('Balance',
              style: AppTextStyles.bodyLg, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _fmtMoney(s.balance),
            style: AppTextStyles.headline.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: SmallStatCard(
                  title: 'Income',
                  value: _fmtMoney(s.income),
                  background: AppColors.primaryLight,
                  border: AppColors.neutral200,
                  valueColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: SmallStatCard(
                  title: 'Expenses',
                  value: _fmtMoney(s.expense),
                  background: AppColors.secondaryLight,
                  border: AppColors.neutral200,
                  valueColor: AppColors.secondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          Text('Top Expenses', style: AppTextStyles.bodyLg),
          const SizedBox(height: AppSpacing.sm),

          ...s.topExpenses.map(
            (e) => TopExpenseRow(
              title: e.categoryName,
              amount: _fmtMoney(e.amount),
            ),
          ),
        ],
      ),
    );
  }
}

String _fmtMoney(Money m) {
  final v = m.value;
  final s = v.abs().toStringAsFixed(0);
  return v < 0 ? '-\$$s' : '\$$s';
}
