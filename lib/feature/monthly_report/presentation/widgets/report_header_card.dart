import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/value_objects/money.dart';
import '../cubit/monthly_report_state.dart';
import 'shared/report_card.dart';
import 'shared/mini_stat_chip.dart';
import 'tab_switcher.dart';

class ReportHeaderCard extends StatelessWidget {
  final MonthlyReportState state;
  final ValueChanged<MonthlyReportTab> onTabChanged;

  const ReportHeaderCard({
    super.key,
    required this.state,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    // ========= REAL DATA =========
    final income = state.summary?.income ?? Money.zero;
    final expense = state.summary?.expense ?? Money.zero;
    final balance = state.summary?.balance ?? (income - expense);

    return ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: MiniStatChip(
                  kind: ChipKind.income,
                  label: 'INCOME',
                  value: _moneyText(income),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: MiniStatChip(
                  kind: ChipKind.expense,
                  label: 'EXPENSES',
                  value: _moneyText(expense),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: MiniStatChip(
                  kind: ChipKind.balance,
                  label: 'BALANCE',
                  value: _moneyText(balance),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          TabSwitcher(
            selected: state.tab,
            onChanged: onTabChanged,
          ),
        ],
      ),
    );
  }

  String _moneyText(Money m) {
    // format basic giống UI demo: $3,200
    final v = m.value;
    final sign = v < 0 ? '-' : '';
    final abs = v.abs();

    // Không dùng intl để bạn khỏi phải add package
    final s = abs.toStringAsFixed(0);
    final withComma = _comma(s);

    return '$sign\$$withComma';
  }

  String _comma(String digits) {
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      final left = digits.length - i;
      buf.write(digits[i]);
      if (left > 1 && left % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }
}
