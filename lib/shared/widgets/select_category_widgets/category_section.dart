// lib/shared/widgets/select_category_widgets/category_section.dart
//
// Section header + spacing matches screenshot:
// - Small blue uppercase label ("EXPENSE", "INCOME")
// - Cards stacked with consistent spacing
// Function unchanged.

import 'package:flutter/material.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';

import 'category_item_tile.dart';

class CategorySection extends StatelessWidget {
  final String title;
  final List<CategoryEntity> items;
  final int? selectedId;
  final ValueChanged<CategoryEntity> onTap;

  const CategorySection({
    super.key,
    required this.title,
    required this.items,
    required this.selectedId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 10),

        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No categories',
              style: AppTextStyles.body.copyWith(color: AppColors.neutral600),
            ),
          )
        else
          ...items.map((c) {
            final isSelected = c.id == selectedId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CategoryItemTile(
                category: c,
                isSelected: isSelected,
                onTap: () => onTap(c),
              ),
            );
          }),
      ],
    );
  }
}
