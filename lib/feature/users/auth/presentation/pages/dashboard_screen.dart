import 'package:flutter/material.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/shared/widgets/ui_kit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
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
                    title: 'Dashboard',
                    style: tt.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const SummaryRow(
                    items: [
                      SummaryItem(
                        label: 'INCOME',
                        value: '\$2,600',
                        background: Color(0xFF5AA9A6),
                      ),
                      SummaryItem(
                        label: 'EXPENSES',
                        value: '\$1,400',
                        background: Color(0xFFF2A34B),
                      ),
                      SummaryItem(
                        label: 'BALANCE',
                        value: '\$1,200',
                        background: Color(0xFF0B6B6B),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const DonutAndLegend(
                    income: 2600,
                    expenses: 1400,
                    incomeColor: Color(0xFF5AA9A6),
                    expensesColor: Color(0xFFF2A34B),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Recent Transactions',
                    style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const TransactionTile(
                    icon: Icons.attach_money,
                    iconColor: Color(0xFF5AA9A6),
                    title: 'Salary',
                    date: 'Apr 25',
                    amountPrimary: '\$2000',
                    amountSecondary: '\$200',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const TransactionTile(
                    icon: Icons.restaurant,
                    iconColor: Color(0xFFF2A34B),
                    title: 'Groceries',
                    date: 'Apr 24',
                    amountPrimary: '\$120',
                    amountSecondary: '\$120',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const TransactionTile(
                    icon: Icons.home,
                    iconColor: Color(0xFFF2A34B),
                    title: 'Apartment',
                    date: 'Apr 22',
                    amountPrimary: '\$850',
                    amountSecondary: '\$850',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        currentIndex: _navIndex,
        onChanged: (i) => setState(() => _navIndex = i),
        items: const [
          DashboardNavItem(icon: Icons.home, label: 'Home'),
          DashboardNavItem(icon: Icons.add, label: 'Add'),
          DashboardNavItem(icon: Icons.history, label: 'History'),
          DashboardNavItem(icon: Icons.bar_chart, label: 'Report'),
          DashboardNavItem(icon: Icons.settings, label: 'Settings'),
        ],
      ),
    );
  }
}
