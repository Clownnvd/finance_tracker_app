import 'package:flutter/material.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';

class LegendRow extends StatelessWidget {
  final Color color;
  final String label;

  const LegendRow({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 14,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadius.pill,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: tt.bodyMedium),
      ],
    );
  }
}
