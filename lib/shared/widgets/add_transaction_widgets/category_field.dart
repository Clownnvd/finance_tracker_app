// lib/shared/widgets/add_transaction_widgets/category_field.dart
// Orange border + light orange fill like screenshot.

import 'package:flutter/material.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';

class CategoryField extends StatelessWidget {
  final CategoryEntity? value;
  final VoidCallback onTap;

  const CategoryField({
    super.key,
    required this.value,
    required this.onTap,
  });

  // Match screenshot orange + tint.
  static const Color _accentOrange = Color(0xFFFF7A00);
  static const Color _accentOrangeLight = Color(0xFFFFE8D6);

  IconData _iconFor(CategoryEntity? c) {
    final key = (c?.icon ?? '').trim().toLowerCase();
    final name = (c?.name ?? '').trim().toLowerCase();

    if (key == 'house' || key == 'housing' || key == 'home' || name.contains('hous')) {
      return Icons.home_rounded;
    }
    if (key == 'food' || name.contains('food')) return Icons.restaurant_rounded;
    if (key.contains('shop') || name.contains('shop')) return Icons.shopping_bag_rounded;
    if (key == 'salary' || name.contains('salary')) return Icons.payments_rounded;
    if (key == 'freelance' || name.contains('free')) return Icons.work_rounded;
    if (key.contains('invest') || name.contains('invest')) return Icons.trending_up_rounded;

    return Icons.category_rounded;
  }

  Color _iconColor(CategoryEntity? c) {
    final name = (c?.name ?? '').trim().toLowerCase();
    if (name.contains('salary')) return const Color(0xFF2F9E9A);
    if (name.contains('shop')) return AppColors.primaryDark;
    return _accentOrange; // orange like screenshot (Housing icon)
  }

  @override
  Widget build(BuildContext context) {
    final selected = value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.medium,
            onTap: onTap,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: selected ? _accentOrangeLight : AppColors.white,
                borderRadius: AppRadius.medium,
                border: Border.all(
                  color: selected ? _accentOrange : AppColors.primaryLight,
                  width: selected ? 1.8 : 1.4,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _iconFor(value),
                    size: 22,
                    color: selected ? _iconColor(value) : AppColors.neutral400,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selected ? value!.name : 'Select category',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: selected ? AppColors.neutral900 : AppColors.neutral500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
