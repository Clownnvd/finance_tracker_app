import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import 'report_card.dart';

class ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorCard({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Error', style: AppTextStyles.title.copyWith(color: AppColors.error)),
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
