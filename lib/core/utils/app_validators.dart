import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';

/// Unified validators for Auth.
/// - Use in UI (returns String? error)
/// - Use in Domain/UseCases (throws ValidationException)
class AuthValidators {
  AuthValidators._();

  // Basic email validation (sufficient for most apps)
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Only letters + spaces (Latin). If you need Vietnamese unicode letters,
  // tell me and I'll switch this regex to unicode-safe.
  static final RegExp _fullNameRegex = RegExp(r'^[a-zA-Z\s]+$');

  static final RegExp _hasUpper = RegExp(r'[A-Z]');
  static final RegExp _hasLower = RegExp(r'[a-z]');
  static final RegExp _hasNumber = RegExp(r'[0-9]');
  static final RegExp _hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  // =======================
  // Domain-style (throw)
  // =======================

  static void validateEmail(String email) {
    final v = email.trim();

    if (v.isEmpty) {
      throw const ValidationException(AppStrings.emailRequired);
    }
    if (!_emailRegex.hasMatch(v)) {
      throw const ValidationException(AppStrings.invalidEmailFormat);
    }
  }

  static void validatePassword(String password) {
    if (password.isEmpty) {
      throw const ValidationException(AppStrings.passwordRequired);
    }
    if (password.length < 8) {
      throw const ValidationException(AppStrings.passwordMinLength8);
    }
    if (!_hasUpper.hasMatch(password)) {
      throw const ValidationException(AppStrings.passwordNeedUppercase);
    }
    if (!_hasLower.hasMatch(password)) {
      throw const ValidationException(AppStrings.passwordNeedLowercase);
    }
    if (!_hasNumber.hasMatch(password)) {
      throw const ValidationException(AppStrings.passwordNeedNumber);
    }
    if (!_hasSpecial.hasMatch(password)) {
      throw const ValidationException(AppStrings.passwordNeedSpecialChar);
    }
  }

  static void validateConfirmPassword(String confirmPassword, String password) {
    if (confirmPassword.isEmpty) {
      throw const ValidationException(AppStrings.confirmPasswordRequired);
    }
    if (confirmPassword != password) {
      throw const ValidationException(AppStrings.passwordNotMatch);
    }
  }

  static void validateFullName(String fullName) {
    final v = fullName.trim();

    if (v.isEmpty) {
      throw const ValidationException(AppStrings.fullNameRequired);
    }
    if (v.length < 2) {
      throw const ValidationException(AppStrings.fullNameMinLength2);
    }
    if (!_fullNameRegex.hasMatch(v)) {
      throw const ValidationException(AppStrings.fullNameInvalidChars);
    }
  }

  // =======================
  // UI-style (String?)
  // =======================

  static String? email(String? value) {
    try {
      validateEmail(value ?? '');
      return null;
    } on ValidationException catch (e) {
      return e.message;
    }
  }

  static String? password(String? value) {
    try {
      validatePassword(value ?? '');
      return null;
    } on ValidationException catch (e) {
      return e.message;
    }
  }

  static String? confirmPassword(String? value, String password) {
    try {
      validateConfirmPassword(value ?? '', password);
      return null;
    } on ValidationException catch (e) {
      return e.message;
    }
  }

  static String? fullName(String? value) {
    try {
      validateFullName(value ?? '');
      return null;
    } on ValidationException catch (e) {
      return e.message;
    }
  }
}

/// Backward-compatible alias (so you don't have to refactor all UI immediately).
/// You can gradually migrate `AppValidators.email` -> `AuthValidators.email`.
class AppValidators {
  AppValidators._();

  static String? email(String? value) => AuthValidators.email(value);
  static String? password(String? value) => AuthValidators.password(value);
  static String? confirmPassword(String? value, String password) =>
      AuthValidators.confirmPassword(value, password);
  static String? fullName(String? value) => AuthValidators.fullName(value);
}
