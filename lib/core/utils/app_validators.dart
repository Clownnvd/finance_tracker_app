import 'package:email_validator/email_validator.dart';
import 'package:finance_tracker_app/core/utils/validation_messages.dart';

class AppValidators {
  static String? email(String? value) {
    final v = value?.trim();

    if (v == null || v.isEmpty) {
      return ValidationMessages.enterEmail;
    }

    if (!EmailValidator.validate(v)) {
      return ValidationMessages.invalidEmail;
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.enterPassword;
    }

    if (value.length < 8) {
      return ValidationMessages.shortPassword;
    }

    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return ValidationMessages.passwordNeedLetter;
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return ValidationMessages.passwordNeedNumber;
    }

    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.confirmPassword;
    }

    if (value != password) {
      return ValidationMessages.passwordMismatch;
    }

    return null;
  }
}
