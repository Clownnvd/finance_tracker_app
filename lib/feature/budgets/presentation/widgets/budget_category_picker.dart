import 'package:flutter/material.dart';

import 'package:finance_tracker_app/core/theme/app_theme.dart';

class BudgetCategoryPicker extends StatelessWidget {
  final String title;
  final String valueText;
  final IconData icon;
  final VoidCallback? onTap;

  const BudgetCategoryPicker({
    super.key,
    required this.title,
    required this.valueText,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.caption),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: AppRadius.medium,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppRadius.medium,
              border: Border.all(color: AppColors.neutral200),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.secondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    valueText,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.neutral500),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
