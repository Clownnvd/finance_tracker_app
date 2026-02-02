import 'package:flutter/material.dart';

import 'package:finance_tracker_app/core/theme/app_theme.dart';

class BudgetAmountInput extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const BudgetAmountInput({
    super.key,
    required this.title,
    required this.hintText,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.caption),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: BorderSide(color: AppColors.neutral200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.medium,
              borderSide: BorderSide(color: AppColors.neutral200),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
