// lib/feature/dashboard/presentation/pages/dashboard_screen.dart
import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker_app/shared/widgets/ui_kit.dart';

import 'package:finance_tracker_app/feature/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:finance_tracker_app/feature/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:finance_tracker_app/feature/dashboard/domain/entities/dashboard_entities.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;

  static const Color _incomeColor = Color(0xFF5AA9A6);
  static const Color _expenseColor = Color(0xFFF2A34B);
  static const Color _balanceColor = Color(0xFF0B6B6B);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<DashboardCubit>().load(recentLimit: 3));
  }

  String _money(double v) {
    final x = v.round();
    final s = x.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      b.write(s[i]);
      if (idx > 1 && idx % 3 == 1) b.write(',');
    }
    return '\$${b.toString()}';
  }

  String _dateShort(DateTime d) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${m[d.month - 1]} ${d.day}';
  }

  IconData _iconFromString(String icon) {
    switch (icon) {
      case 'money':
        return Icons.attach_money;
      case 'work':
        return Icons.work_outline;
      case 'food':
        return Icons.restaurant;
      case 'shopping_cart':
        return Icons.shopping_cart_outlined;
      case 'house':
        return Icons.home_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  Color _colorForTx(DashboardTransaction tx) {
    return tx.isIncome ? _incomeColor : _expenseColor;
  }

  Future<void> _refresh() async {
    await context.read<DashboardCubit>().refresh(recentLimit: 3);
  }

  void _onNavChanged(int index) {
    if (index == 1) {
      Navigator.of(context).pushNamed(AppRoutes.addTransaction);
      return;
    }

    if (index == 2) {
      Navigator.of(context).pushNamed(AppRoutes.transactionHistory);
      return;
    }

    setState(() => _navIndex = index);

    if (index == 3) {
      return;
    }

    if (index == 4) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<DashboardCubit, DashboardState>(
          listenWhen: (prev, next) => prev.error != next.error,
          listener: (context, state) {
            final msg = state.error;
            if (msg != null && msg.trim().isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(msg.trim())));
            }
          },
          builder: (context, state) {
            final summary = state.data?.summary;

            final income = summary?.income ?? 0.0;
            final expenses = summary?.expenses ?? 0.0;
            final balance = (summary == null) ? 0.0 : (income - expenses);

            final isLoading = state.isLoading;

            return Stack(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: RefreshIndicator(
                      onRefresh: _refresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.lg,
                          AppSpacing.xl,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DashboardHeader(
                              title: AppStrings.dashboardTitle,
                              style: tt.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),

                            SummaryRow(
                              items: [
                                SummaryItem(
                                  label: AppStrings.income,
                                  value: _money(income),
                                  background: _incomeColor,
                                ),
                                SummaryItem(
                                  label: AppStrings.expenses,
                                  value: _money(expenses),
                                  background: _expenseColor,
                                ),
                                SummaryItem(
                                  label: AppStrings.balance,
                                  value: _money(balance),
                                  background: _balanceColor,
                                ),
                              ],
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            DonutAndLegend(
                              income: income,
                              expenses: expenses,
                              incomeColor: _incomeColor,
                              expensesColor: _expenseColor,
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            Text(
                              AppStrings.recentTransactions,
                              style: tt.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),

                            if (state.recent.isEmpty && !isLoading)
                              const Padding(
                                padding: EdgeInsets.only(top: AppSpacing.md),
                                child: Text(AppStrings.noTransactionsYet),
                              )
                            else
                              ...state.recent.map((tx) {
                                final color = _colorForTx(tx);
                                final secondary = (tx.note == null ||
                                        tx.note!.trim().isEmpty)
                                    ? null
                                    : tx.note!.trim();

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.sm,
                                  ),
                                  child: TransactionTile(
                                    icon: _iconFromString(tx.icon),
                                    iconColor: color,
                                    title: tx.title,
                                    date: _dateShort(tx.date),
                                    amountPrimary: _money(tx.amount),
                                    amountSecondary: secondary ?? '',
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                if (isLoading)
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        color: Colors.black.withOpacity(0.06),
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 12),
                        child: const LinearProgressIndicator(minHeight: 3),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        currentIndex: _navIndex,
        onChanged: _onNavChanged,
        items: const [
          DashboardNavItem(icon: Icons.home, label: AppStrings.navHome),
          DashboardNavItem(icon: Icons.add, label: AppStrings.navAdd),
          DashboardNavItem(icon: Icons.history, label: AppStrings.navHistory),
          DashboardNavItem(icon: Icons.bar_chart, label: AppStrings.navReport),
          DashboardNavItem(icon: Icons.settings, label: AppStrings.navSettings),
        ],
      ),
    );
  }
}
