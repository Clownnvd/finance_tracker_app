import 'package:finance_tracker_app/shared/widgets/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/constants/app_config.dart';
import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/core/utils/app_validators.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/auth_state.dart';
import 'package:finance_tracker_app/gen/assets.gen.dart';
import 'package:finance_tracker_app/shared/widgets/ui_kit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(bool isLoading) {
    if (isLoading) return;

    AuthUi.unfocus(context);

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context.read<AuthCubit>().login(
          _emailController.text.trim(),
          _passwordController.text, // do NOT trim password
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (prev, next) => next is AuthFailure || next is AuthSuccess,
          listener: (context, state) {
            if (state is AuthFailure) {
              AuthUi.snack(context, state.message);
              return;
            }

            if (state is AuthSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.dashboard,
                (_) => false,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return AuthLoadingOverlay(
              isLoading: isLoading,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.xl),

                        Text(
                          AppStrings.welcomeTitle,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineMedium,
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        Assets.images.loginImg.image(
                          width: AppConfig.authImageWidth,
                          height: AppConfig.authImageHeight,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        /// Email — unified validation
                        AppValidatedTextField(
                          controller: _emailController,
                          label: AppStrings.emailLabel,
                          keyboardType: TextInputType.emailAddress,
                          validator: AuthValidators.email,
                          enabled: !isLoading,
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: AppSpacing.xs),

                        /// Password — unified validation
                        AppValidatedTextField(
                          controller: _passwordController,
                          label: AppStrings.passwordLabel,
                          obscureText: _isPasswordHidden,
                          keyboardType: TextInputType.visiblePassword,
                          validator: AuthValidators.password,
                          enabled: !isLoading,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _onLoginPressed(isLoading),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordHidden
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            onPressed: isLoading
                                ? null
                                : () => setState(() {
                                      _isPasswordHidden = !_isPasswordHidden;
                                    }),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        SizedBox(
                          height: AppSpacing.xxl * 1.35,
                          child: ElevatedButton(
                            onPressed:
                                isLoading ? null : () => _onLoginPressed(isLoading),
                            child: isLoading
                                ? const SizedBox(
                                    width: AppConfig.loaderSize,
                                    height: AppConfig.loaderSize,
                                    child: CircularProgressIndicator(
                                      strokeWidth: AppConfig.loaderStrokeWidth,
                                    ),
                                  )
                                : Text(
                                    AppStrings.login,
                                    style: textTheme.titleMedium,
                                  ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        IgnorePointer(
                          ignoring: isLoading,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.dontHaveAccount,
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.signUp,
                                ),
                                child: Text(
                                  AppStrings.register,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
