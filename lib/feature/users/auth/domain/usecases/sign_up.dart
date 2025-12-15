import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/utils/validation_messages.dart';

import '../entities/user_model.dart';
import '../repositories/auth_repository.dart';

class Signup {
  final AuthRepository repository;

  Signup(this.repository);

  Future<UserModel> call({
    required String email,
    required String password,
    required String fullName,
  }) {
    final trimmedEmail = email.trim();
    final trimmedName = fullName.trim();

    _validateFullName(trimmedName);
    _validateEmail(trimmedEmail);
    _validatePassword(password);

    return repository.signup(
      email: trimmedEmail,
      password: password,
      fullName: trimmedName,
    );
  }


  void _validateFullName(String name) {
    if (name.isEmpty) {
      throw const ValidationException(
        ValidationMessages.enterFullName,
      );
    }
  }

  void _validateEmail(String email) {
    if (email.isEmpty) {
      throw const ValidationException(
        ValidationMessages.enterEmail,
      );
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      throw const ValidationException(
        ValidationMessages.invalidEmail,
      );
    }
  }

  void _validatePassword(String password) {
    if (password.isEmpty) {
      throw const ValidationException(
        ValidationMessages.enterPassword,
      );
    }

    if (password.length < 8) {
      throw const ValidationException(
        ValidationMessages.shortPassword,
      );
    }

    if (!RegExp(r'[A-Za-z]').hasMatch(password)) {
      throw const ValidationException(
        ValidationMessages.passwordNeedLetter,
      );
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      throw const ValidationException(
        ValidationMessages.passwordNeedNumber,
      );
    }
  }
}
