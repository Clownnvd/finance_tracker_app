import 'package:finance_tracker_app/core/error/exceptions.dart';

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

    if (trimmedName.isEmpty) {
      throw const ValidationException('Full name cannot be empty');
    }

    if (trimmedEmail.isEmpty) {
      throw const ValidationException('Email cannot be empty');
    }

    if (!trimmedEmail.contains('@') || !trimmedEmail.contains('.')) {
      throw const ValidationException('Invalid email format');
    }

    final parts = trimmedEmail.split('@');
    if (parts.length != 2 || parts[1].trim().isEmpty) {
      throw const ValidationException('Invalid email domain');
    }

    if (password.isEmpty) {
      throw const ValidationException('Password cannot be empty');
    }

    if (password.length < 8) {
      throw const ValidationException('Password must be at least 8 characters');
    }

    if (!RegExp(r'[A-Za-z]').hasMatch(password)) {
      throw const ValidationException(
        'Password must include at least one letter',
      );
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      throw const ValidationException(
        'Password must include at least one number',
      );
    }

    return repository.signup(
      email: trimmedEmail,
      password: password,
      fullName: trimmedName,
    );
  }
}
