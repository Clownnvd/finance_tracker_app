import 'package:flutter/material.dart';

import 'package:finance_tracker_app/core/theme/app_theme.dart';

class SettingsNavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingsNavItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.medium,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppTextStyles.bodyLg)),
            const Icon(Icons.chevron_right, color: AppColors.neutral500),
          ],
        ),
      ),
    );
  }
}
