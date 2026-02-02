import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../cubit/monthly_report_cubit.dart';
import '../cubit/monthly_report_state.dart';

import 'report_header_card.dart';
import 'shared/loading_card.dart';
import 'shared/error_card.dart';
import 'tabs/monthly_tab.dart';
import 'tabs/category_tab.dart';
import 'tabs/summary_tab.dart';

class MonthlyReportView extends StatelessWidget {
  const MonthlyReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Report'),
        centerTitle: true,
      ),
      body: BlocBuilder<MonthlyReportCubit, MonthlyReportState>(
        builder: (context, state) {
          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = math.min(constraints.maxWidth, 360.0);

                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: maxWidth,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          /// ===== HEADER + TAB SWITCHER =====
                          ReportHeaderCard(
                            state: state,
                            onTabChanged: (tab) => context
                                .read<MonthlyReportCubit>()
                                .changeTab(tab),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          /// ===== BODY =====
                          if (state.isLoading) ...[
                            const LoadingCard(),
                          ] else if (state.errorMessage != null) ...[
                            ErrorCard(
                              message: state.errorMessage!,
                              onRetry: () => context
                                  .read<MonthlyReportCubit>()
                                  .retry(),
                            ),
                          ] else ...[
                            _TabBody(state: state),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TabBody extends StatelessWidget {
  const _TabBody({required this.state});
  final MonthlyReportState state;

  @override
  Widget build(BuildContext context) {
    switch (state.tab) {
      case MonthlyReportTab.monthly:
        return MonthlyTab(
          trend: state.trend,
          summary: state.summary,
          selectedMonth: state.selectedMonth,
          onMonthChanged: (m) =>
              context.read<MonthlyReportCubit>().changeMonth(m),
        );

      case MonthlyReportTab.category:
        return CategoryTab(
          expense: state.expenseCategories,
          income: state.incomeCategories,
        );

      case MonthlyReportTab.summary:
        return SummaryTab(
          summary: state.summary,
        );
    }
  }
}
