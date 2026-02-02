import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import 'report_card.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReportCard(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
