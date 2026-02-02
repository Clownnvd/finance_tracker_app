import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/monthly_summary.dart';
import '../../../domain/entities/monthly_trend.dart';
import '../../../domain/value_objects/money.dart';
import '../../../domain/value_objects/report_month.dart';

import '../charts/line_chart.dart';
import '../shared/report_card.dart';
import '../shared/small_stat_card.dart';
import '../shared/month_dropdown.dart';
import '../shared/orange_button.dart';

class MonthlyTab extends StatelessWidget {
  const MonthlyTab({
    super.key,
    required this.trend,
    required this.summary,
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  final MonthlyTrend? trend;
  final MonthlySummary? summary;
  final ReportMonth selectedMonth;
  final ValueChanged<ReportMonth> onMonthChanged;

  @override
  Widget build(BuildContext context) {
    final s = summary;
    final t = trend;

    return ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 180,
            child: t == null
                ? const Center(child: Text('No trend data'))
                : LineChart(trend: t),
          ),
          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: SmallStatCard(
                  title: 'INCOME',
                  value: s != null ? _fmtMoney(s.income) : '\$0',
                  background: AppColors.primaryLight,
                  border: AppColors.neutral200,
                  valueColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: SmallStatCard(
                  title: 'EXPENSE',
                  value: s != null ? _fmtMoney(s.expense) : '\$0',
                  background: AppColors.secondaryLight,
                  border: AppColors.neutral200,
                  valueColor: AppColors.secondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          MonthDropdown(
            selected: selectedMonth,
            onChanged: onMonthChanged,
          ),

          const SizedBox(height: AppSpacing.md),

          OrangeButton(text: 'Export as PDF', onPressed: () {}),
          const SizedBox(height: AppSpacing.sm),
          OrangeButton(text: 'Send via Email', onPressed: () {}),
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
