import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

enum ChipKind { income, expense, balance }

class MiniStatChip extends StatelessWidget {
  final ChipKind kind;
  final String label;
  final String value;

  const MiniStatChip({
    super.key,
    required this.kind,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (kind) {
      case ChipKind.income:
        bg = AppColors.primaryLight;
        fg = AppColors.primary;
        break;
      case ChipKind.expense:
        bg = AppColors.secondaryLight;
        fg = AppColors.secondary;
        break;
      case ChipKind.balance:
        bg = const Color(0xFFE8F5E9);
        fg = AppColors.success;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: fg,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyLg.copyWith(
              color: fg,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
