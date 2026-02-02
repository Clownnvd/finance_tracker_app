import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class TopExpenseRow extends StatelessWidget {
  final String title;
  final String amount;

  const TopExpenseRow({
    super.key,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, size: 18, color: AppColors.secondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(title, style: AppTextStyles.body)),
          Text(amount, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
