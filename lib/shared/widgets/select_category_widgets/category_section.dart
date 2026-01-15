import 'package:flutter/material.dart';
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
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: tt.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),

        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No categories',
              style: tt.bodyMedium,
            ),
          )
        else
          ...items.map((c) {
            final isSelected = c.id == selectedId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CategoryItemTile(
                category: c,
                isSelected: isSelected,
                onTap: () => onTap(c),
              ),
            );
          }).toList(),
      ],
    );
  }
}
