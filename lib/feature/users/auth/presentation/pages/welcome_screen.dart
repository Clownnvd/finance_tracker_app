import 'package:flutter/material.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/gen/assets.gen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ts = theme.textTheme;
    final cs = theme.colorScheme;

    final wallet = Assets.icons.walletSolid.svg(
      width: 200,
      height: 200,
      colorFilter: ColorFilter.mode(cs.primary, BlendMode.srcIn),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                wallet,
                const SizedBox(height: AppSpacing.lg),
                Text(
                  AppStrings.welcome,
                  style: ts.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  AppStrings.welcomeSubtitle,
                  textAlign: TextAlign.center,
                  style: ts.bodyLarge?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.xxl * 1.3,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.login,
                    ),
                    child: Text(
                      AppStrings.getStarted,
                      style: ts.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
