import 'package:flutter/material.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';

class CategoryItemTile extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItemTile({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  IconData _iconFromString(String icon) {
    switch (icon) {
      case 'money':
        return Icons.attach_money;
      case 'work':
        return Icons.work_outline;
      case 'food':
        return Icons.restaurant;
      case 'shopping_cart':
        return Icons.shopping_cart_outlined;
      case 'house':
        return Icons.home_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary.withOpacity(0.08) : cs.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _iconFromString(category.icon),
              size: 20,
              color: isSelected ? cs.primary : cs.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 18,
                color: cs.primary,
              ),
          ],
        ),
      ),
    );
  }
}
