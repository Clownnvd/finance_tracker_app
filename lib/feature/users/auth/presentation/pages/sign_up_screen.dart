import 'package:finance_tracking_app/core/theme/app_theme.dart';
import 'package:finance_tracking_app/core/utils/app_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracking_app/gen/assets.gen.dart';
import 'package:finance_tracking_app/core/router/app_router.dart';
import 'package:finance_tracking_app/feature/users/auth/presentation/cubit/auth_cubit.dart';
import 'package:finance_tracking_app/feature/users/auth/presentation/cubit/auth_state.dart';
import 'package:finance_tracking_app/shared/widgets/ui_kit.dart';

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

  void _onSignUpPressed(BuildContext context) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context.read<AuthCubit>().signup(
          _fullNameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme; // colorScheme
    final ts = theme.textTheme;   // textTheme

    final signUpImage = Assets.images.signUpImg.image(
      width: 240,
      height: 120,
      fit: BoxFit.contain,
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) _showSnack(state.message);
              if (state is AuthSuccess) {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.lg),

                      Text(
                        'Sign Up',
                        style: ts.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      signUpImage,

                      const SizedBox(height: AppSpacing.xl),

                      /// FULL NAME
                      AppValidatedTextField(
                        controller: _fullNameController,
                        label: 'Full Name',
                        keyboardType: TextInputType.name,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Please enter your full name'
                                : null,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      /// EMAIL
                      AppValidatedTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidators.email,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      /// PASSWORD
                      AppValidatedTextField(
                        controller: _passwordController,
                        label: 'Password',
                        obscureText: !_showPassword,
                        validator: AppValidators.password,
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: cs.onSurfaceVariant,
                          ),
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      /// CONFIRM PASSWORD
                      AppValidatedTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm password',
                        obscureText: !_showConfirmPassword,
                        validator: (value) => AppValidators.confirmPassword(
                            value, _passwordController.text),
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: cs.onSurfaceVariant,
                          ),
                          onPressed: () => setState(
                              () => _showConfirmPassword = !_showConfirmPassword),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      /// BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: AppSpacing.xxl,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            foregroundColor: cs.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed:
                              isLoading ? null : () => _onSignUpPressed(context),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Sign Up',
                                  style: ts.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?", style: ts.bodyMedium),
                          const SizedBox(width: AppSpacing.xs),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, AppRoutes.login),
                            child: Text(
                              "Login",
                              style: ts.bodyMedium?.copyWith(
                                color: cs.primary,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
