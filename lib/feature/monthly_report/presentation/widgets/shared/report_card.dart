import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class ReportCard extends StatelessWidget {
  final Widget child;
  const ReportCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.neutral200),
        boxShadow: AppShadows.level2,
      ),
      child: child,
    );
  }
}
