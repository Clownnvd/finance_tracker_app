import 'package:email_validator/email_validator.dart';
import 'package:finance_tracker_app/core/constants/strings.dart';

class AppValidators {
  static String? email(String? value) {
    final v = value?.trim();

    if (v == null || v.isEmpty) {
      return AppStrings.emailRequired;
    }

    if (!EmailValidator.validate(v)) {
      return AppStrings.invalidEmailFormat;
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    if (value.length < 8) {
      return AppStrings.passwordMinLength8;
    }

    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.confirmPasswordRequired;
    }

    if (value != password) {
      return AppStrings.passwordNotMatch;
    }

    return null;
  }
}
