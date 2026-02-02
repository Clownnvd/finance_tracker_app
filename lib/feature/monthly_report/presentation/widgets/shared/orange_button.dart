import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class OrangeButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const OrangeButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
        ),
        onPressed: onPressed,
        child: Text(text, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
      ),
    );
  }
}
