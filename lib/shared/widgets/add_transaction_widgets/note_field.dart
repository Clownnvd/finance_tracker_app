// lib/shared/widgets/add_transaction_widgets/note_field.dart
// Screenshot UI: label blue, multiline rounded box, hint "Write a note"

import 'package:flutter/material.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';

class NoteField extends StatelessWidget {
  final TextEditingController controller;

  const NoteField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note',
          style: AppTextStyles.bodyLg.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 4,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.neutral900,
          ),
          decoration: InputDecoration(
            hintText: 'Write a note',
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.neutral400,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.all(14),
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
      ],
    );
  }
}
