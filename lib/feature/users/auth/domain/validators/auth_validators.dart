import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';

class AuthValidators {
  static String _trim(String v) => v.trim();

  static String validateEmail(String email) {
    final e = _trim(email);

    if (e.isEmpty) {
      throw const ValidationException(AppStrings.emailRequired);
    }

    if (!e.contains('@') || !e.contains('.')) {
      throw const ValidationException(AppStrings.invalidEmailFormat);
    }

    final parts = e.split('@');
    if (parts.length != 2 || parts[1].trim().isEmpty) {
      throw const ValidationException(AppStrings.invalidEmailFormat);
    }

    return e;
  }

  static void validatePassword(String password) {
    if (password.isEmpty) {
      throw const ValidationException(AppStrings.passwordRequired);
    }

    if (password.length < 8) {
      throw const ValidationException(AppStrings.passwordMinLength8);
    }
  }

  static String validateFullName(String fullName) {
    final n = _trim(fullName);

    if (n.isEmpty) {
      throw const ValidationException(AppStrings.fullNameRequired);
    }

    return n;
  }
}
