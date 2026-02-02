import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/settings/presentation/cubit/settings_cubit.dart';
import 'package:finance_tracker_app/feature/settings/presentation/cubit/settings_state.dart';

import '../widgets/no_budget_dialog.dart';
import '../widgets/settings_nav_item.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_switch_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SettingsCubit>().load());
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = math.min(MediaQuery.of(context).size.width, 420.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listenWhen: (p, n) =>
            p.errorMessage != n.errorMessage ||
            (!p.shouldPromptSetBudget && n.shouldPromptSetBudget),
        listener: (context, state) async {
          final msg = state.errorMessage;
          if (msg != null && msg.trim().isNotEmpty) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(msg.trim())));
          }

          if (state.shouldPromptSetBudget) {
            context.read<SettingsCubit>().consumePrompt();
            final go = await showNoBudgetDialog(context);

            if (go == true && context.mounted) {
              Navigator.of(context).pushNamed(AppRoutes.setBudget);
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: maxWidth,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    SettingsSection(
                      children: [
                        SettingsSwitchItem(
                          title: 'Transaction Reminder',
                          subtitle:
                              'Remind to add your expenses\nand incomes daily',
                          value: state.settings.reminderOn,
                          enabled: !state.isLoading,
                          onChanged: (v) =>
                              context.read<SettingsCubit>().toggleReminder(v),
                        ),
                        SettingsSwitchItem(
                          title: 'Budget Limit',
                          subtitle: 'Notify when nearing your\nbudget limit.',
                          value: state.settings.budgetAlertOn,
                          enabled: !state.isLoading,
                          onChanged: (v) => context
                              .read<SettingsCubit>()
                              .toggleBudgetLimit(v),
                        ),
                        SettingsSwitchItem(
                          title: 'Tips & Recommendations',
                          subtitle:
                              'Get helpful suggestions for\nmanaging your finances',
                          value: state.settings.tipsOn,
                          enabled: !state.isLoading,
                          onChanged: (v) =>
                              context.read<SettingsCubit>().toggleTips(v),
                        ),
                        SettingsNavItem(
                          title: 'Account & Security',
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.accountSecurity);
                          },
                        ),
                      ],
                    ),
                    if (state.isLoading) ...[
                      const SizedBox(height: AppSpacing.lg),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
