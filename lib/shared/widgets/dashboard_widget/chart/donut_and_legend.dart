import 'package:flutter/material.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'donut_chart.dart';
import 'donut_segment.dart';
import 'legend_row.dart';

class DonutAndLegend extends StatelessWidget {
  final double income;
  final double expenses;
  final Color incomeColor;
  final Color expensesColor;

  const DonutAndLegend({
    super.key,
    required this.income,
    required this.expenses,
    required this.incomeColor,
    required this.expensesColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 170,
          height: 170,
          child: DonutChart(
            segments: [
              DonutSegment(value: income, color: incomeColor),
              DonutSegment(value: expenses, color: expensesColor),
            ],
            strokeWidth: 26,
            gapRadians: 0.06,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LegendRow(color: incomeColor, label: 'Income'),
              const SizedBox(height: AppSpacing.md),
              LegendRow(color: expensesColor, label: 'Expenses'),
            ],
          ),
        ),
      ],
    );
  }
}
