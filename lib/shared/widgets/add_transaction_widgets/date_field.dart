// lib/shared/widgets/add_transaction_widgets/date_field.dart
// Screenshot UI: label blue, field with date text + right chevron.

import 'package:flutter/material.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';

class DateField extends StatelessWidget {
  final DateTime value;
  final VoidCallback onTap;

  const DateField({
    super.key,
    required this.value,
    required this.onTap,
  });

  String _fmt(DateTime d) {
    // Screenshot format: 4/28/2024
    return '${d.month}/${d.day}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.medium,
            onTap: onTap,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: AppRadius.medium,
                border: const BorderSide(color: AppColors.primaryLight, width: 1.4).toBorder(),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _fmt(value),
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral900,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.neutral600),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

extension on BorderSide {
  BoxBorder toBorder() => Border.fromBorderSide(this);
}
