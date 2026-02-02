import 'package:flutter/material.dart';

import 'package:finance_tracker_app/core/theme/app_theme.dart';

class SettingsSwitchItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.bodyLg),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeThumbColor: AppColors.secondary,
          activeTrackColor: AppColors.secondary.withValues(alpha: 0.4),
        ),
      ],
    );
  }
}
