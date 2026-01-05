import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppValidatedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;

  const AppValidatedTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: BorderSide(color: color, width: 1),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: cs.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hintText ?? label,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
            contentPadding: const EdgeInsets.all(16),
            suffixIcon: suffixIcon,
            border: border(cs.outline),
            enabledBorder: border(cs.outline),
            focusedBorder: border(cs.primary),
            errorBorder: border(cs.error),
            focusedErrorBorder: border(cs.error),
            disabledBorder: border(cs.outlineVariant),
          ),
        ),
      ],
    );
  }
}
