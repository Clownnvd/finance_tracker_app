// lib/shared/widgets/add_transaction_widgets/amount_field.dart
// Screenshot UI: label on top (blue), rounded field, "$2500" hint-like value.

import 'package:flutter/material.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';

class AmountField extends StatelessWidget {
  final TextEditingController controller;

  const AmountField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return _LabeledField(
      label: 'Budget',
      childEnhancer: (child) => child,
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.primaryDark,
        ),
        decoration: InputDecoration(
          hintText: '\$2500',
          hintStyle: AppTextStyles.body.copyWith(
            color: AppColors.primary.withOpacity(0.55),
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.medium,
            borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.medium,
            borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;
  final Widget Function(Widget child) childEnhancer;

  const _LabeledField({
    required this.label,
    required this.child,
    required this.childEnhancer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        childEnhancer(child),
      ],
    );
  }
}
