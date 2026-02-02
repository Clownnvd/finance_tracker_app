import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';
import '../widgets/settings_nav_item.dart';
import '../widgets/settings_section.dart';

class AccountSecurityScreen extends StatelessWidget {
  const AccountSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final maxWidth = math.min(MediaQuery.of(context).size.width, 420.0);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.welcome,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Account & Security'), centerTitle: true),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: maxWidth,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  SettingsSection(
                    children: [
                      SettingsNavItem(title: 'Account', onTap: () {}),
                      SettingsNavItem(title: 'Email', onTap: () {}),
                      SettingsNavItem(title: 'Password', onTap: () {}),
                      SettingsNavItem(
                        title: 'Two-factor\nAuthentication',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: isLoading
                            ? null
                            : () => context.read<AuthCubit>().logout(),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Log Out'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
