import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/category_total.dart';
import '../charts/pie_section.dart';
import '../shared/report_card.dart';

class CategoryTab extends StatelessWidget {
  final List<CategoryTotal> expense;
  final List<CategoryTotal> income;

  const CategoryTab({
    super.key,
    required this.expense,
    required this.income,
  });

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Expenses by Category',
            style: AppTextStyles.title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),

          Text('Expense', style: AppTextStyles.bodyLg),
          const SizedBox(height: AppSpacing.sm),
          PieSection(
            items: expense,
            palette: const [
              Color(0xFFFF8A00),
              Color(0xFF1A73E8),
              Color(0xFF00A88B),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Text('Income', style: AppTextStyles.bodyLg),
          const SizedBox(height: AppSpacing.sm),
          PieSection(
            items: income,
            palette: const [
              Color(0xFF2BB673),
              Color(0xFF1A73E8),
            ],
          ),
        ],
      ),
    );
  }
}
