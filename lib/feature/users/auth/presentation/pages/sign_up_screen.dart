import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/utils/app_validators.dart';
import 'package:finance_tracker_app/gen/assets.gen.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';
import 'package:finance_tracker_app/shared/widgets/ui_kit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed(bool isLoading) {
    if (isLoading) return;

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context.read<AuthCubit>().signup(
          _fullNameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) async {
            if (state is AuthFailure) {
              _showSnack(state.message);
            }

            if (state is AuthSuccess) {
              _showSnack(AppStrings.signUpSuccess);
              await Future.delayed(const Duration(milliseconds: 800));
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            AppStrings.signUpTitle,
                            textAlign: TextAlign.center,
                            style: textTheme.headlineMedium,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Assets.images.signUpImg.image(
                            width: 240,
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          AppValidatedTextField(
                            controller: _fullNameController,
                            label: AppStrings.fullNameLabel,
                            keyboardType: TextInputType.name,
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                    ? AppStrings.fullNameRequired
                                    : null,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppValidatedTextField(
                            controller: _emailController,
                            label: AppStrings.emailLabel,
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidators.email,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppValidatedTextField(
                            controller: _passwordController,
                            label: AppStrings.passwordLabel,
                            obscureText: !_showPassword,
                            keyboardType: TextInputType.visiblePassword,
                            validator: AppValidators.password,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(
                                () => _showPassword = !_showPassword,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppValidatedTextField(
                            controller: _confirmPasswordController,
                            label: AppStrings.confirmPasswordLabel,
                            obscureText: !_showConfirmPassword,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) =>
                                AppValidators.confirmPassword(
                              value,
                              _passwordController.text,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(
                                () => _showConfirmPassword =
                                    !_showConfirmPassword,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          SizedBox(
                            height: AppSpacing.xxl,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _onSignUpPressed(isLoading),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      AppStrings.signUpTitle,
                                      style: textTheme.titleMedium,
                                    ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.alreadyHaveAccount,
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.login,
                                ),
                                child: Text(
                                  AppStrings.login,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: AbsorbPointer(
                      absorbing: true,
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
