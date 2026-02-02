import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/monthly_report_state.dart';

class TabSwitcher extends StatelessWidget {
  final MonthlyReportTab selected;
  final ValueChanged<MonthlyReportTab> onChanged;

  const TabSwitcher({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget tab(String text, MonthlyReportTab tab, bool isSelected) {
      return Expanded(
        child: InkWell(
          borderRadius: AppRadius.pill,
          onTap: () => onChanged(tab),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryLight : AppColors.white,
              borderRadius: AppRadius.pill,
              border: Border.all(color: AppColors.neutral200),
            ),
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(
                color: isSelected ? AppColors.primary : AppColors.neutral600,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab('Monthly', MonthlyReportTab.monthly,
            selected == MonthlyReportTab.monthly),
        const SizedBox(width: AppSpacing.sm),
        tab('Category', MonthlyReportTab.category,
            selected == MonthlyReportTab.category),
        const SizedBox(width: AppSpacing.sm),
        tab('Summary', MonthlyReportTab.summary,
            selected == MonthlyReportTab.summary),
      ],
    );
  }
}
