// lib/shared/widgets/select_category_widgets/category_item_tile.dart
//
// UI matches the screenshot:
// - White card
// - Light blue border
// - Soft shadow
// - Colored icon (category-based)
// - No trailing check icon
// - Selection only changes border thickness/color (no behavior changes)

import 'package:flutter/material.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
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

  // Map category icon keys/names to the exact Material icons used in the screenshot.
  IconData _iconFromCategory(CategoryEntity c) {
    final key = c.icon.trim().toLowerCase();
    final name = c.name.trim().toLowerCase();

    // Prefer explicit icon key first.
    switch (key) {
      // Expense
      case 'food':
        return Icons.restaurant; // fork & knife
      case 'shopping_cart':
      case 'shopping':
        return Icons.shopping_bag; // bag
      case 'house':
      case 'housing':
      case 'home':
        return Icons.home; // house

      // Income
      case 'salary':
      case 'money':
        return Icons.payments; // banknote-like
      case 'freelance':
      case 'work':
        return Icons.work; // briefcase
      case 'investments':
      case 'investment':
      case 'trending_up':
        return Icons.trending_up; // chart arrow
      case 'other':
      case 'people':
      case 'groups':
        return Icons.groups; // group
      default:
        break;
    }

    // Fallback based on the display name.
    if (name.contains('food')) return Icons.restaurant;
    if (name.contains('shop')) return Icons.shopping_bag;
    if (name.contains('hous') || name.contains('home')) return Icons.home;

    if (name.contains('salary')) return Icons.payments;
    if (name.contains('free') || name.contains('work')) return Icons.work;
    if (name.contains('invest')) return Icons.trending_up;
    if (name.contains('other')) return Icons.groups;

    return Icons.category;
  }

  // Category icon colors match screenshot palette.
  Color _iconColor(CategoryEntity c) {
    final key = c.icon.trim().toLowerCase();
    final name = c.name.trim().toLowerCase();

    // Exact palette:
    // - Orange: food/housing/freelance
    // - Blue: shopping/investments/other
    // - Teal: salary
    switch (key) {
      case 'food':
        return AppColors.secondary;
      case 'house':
      case 'housing':
      case 'home':
        return AppColors.secondary;
      case 'shopping_cart':
      case 'shopping':
        return AppColors.primaryDark;
      case 'salary':
      case 'money':
        return const Color(0xFF2F9E9A);
      case 'freelance':
      case 'work':
        return AppColors.secondary;
      case 'investments':
      case 'investment':
      case 'trending_up':
        return AppColors.primaryDark;
      case 'other':
      case 'people':
      case 'groups':
        return AppColors.primaryDark;
      default:
        break;
    }

    if (name.contains('food')) return AppColors.secondary;
    if (name.contains('hous') || name.contains('home')) return AppColors.secondary;
    if (name.contains('free') || name.contains('work')) return AppColors.secondary;

    if (name.contains('salary')) return const Color(0xFF2F9E9A);

    if (name.contains('shop')) return AppColors.primaryDark;
    if (name.contains('invest')) return AppColors.primaryDark;
    if (name.contains('other')) return AppColors.primaryDark;

    return AppColors.primaryDark;
  }

  @override
  Widget build(BuildContext context) {
    final icon = _iconFromCategory(category);
    final iconColor = _iconColor(category);

    // Screenshot-like border: slightly bluish, not grey.
    final borderColor = isSelected ? AppColors.primary : AppColors.primaryLight;
    final borderWidth = isSelected ? 1.6 : 1.2;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.medium,
        onTap: onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.medium,
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: AppShadows.level1,
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
