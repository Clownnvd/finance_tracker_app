import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/value_objects/report_month.dart';

class MonthDropdown extends StatelessWidget {
  final ReportMonth selected;
  final ValueChanged<ReportMonth> onChanged;

  const MonthDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      12,
      (i) => ReportMonth(year: selected.year, month: i + 1),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.neutral200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ReportMonth>(
          value: selected,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items
              .map(
                (m) => DropdownMenuItem(
                  value: m,
                  child: Text(m.label, style: AppTextStyles.body),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
