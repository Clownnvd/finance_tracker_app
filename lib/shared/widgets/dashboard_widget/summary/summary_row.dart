import 'package:flutter/material.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'summary_card.dart';
import 'summary_item.dart';

class SummaryRow extends StatelessWidget {
  final List<SummaryItem> items;

  const SummaryRow({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          Expanded(child: SummaryCard(item: items[i])),
          if (i != items.length - 1) const SizedBox(width: AppSpacing.md),
        ],
      ],
    );
  }
}
