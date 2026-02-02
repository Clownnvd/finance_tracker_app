import 'package:flutter/material.dart';

import 'package:finance_tracker_app/core/theme/app_theme.dart';

class BudgetMonthPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const BudgetMonthPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Month', style: AppTextStyles.caption),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.medium,
            border: Border.all(color: AppColors.neutral200),
          ),
          child: DropdownButton<int>(
            value: value,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            items: List.generate(
              12,
              (i) => DropdownMenuItem(
                value: i + 1,
                child: Text(_monthNames[i]),
              ),
            ),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ],
    );
  }
}
