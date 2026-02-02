import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class SmallStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color background;
  final Color border;
  final Color valueColor;

  const SmallStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.background,
    required this.border,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.medium,
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w800,
              )),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.title.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
