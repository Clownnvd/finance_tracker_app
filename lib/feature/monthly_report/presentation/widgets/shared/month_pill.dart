import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class MonthPill extends StatelessWidget {
  final String text;
  const MonthPill({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Text(text, style: AppTextStyles.body.copyWith(color: AppColors.neutral700)),
    );
  }
}
