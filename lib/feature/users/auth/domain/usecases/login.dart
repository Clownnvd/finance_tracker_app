import 'package:finance_tracker_app/core/error/exceptions.dart';
import '../entities/user_model.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;
  Login(this.repository);

  Future<UserModel> call({required String email, required String password}) {
    if (email.trim().isEmpty) {
      throw const ValidationException('Email cannot be empty');
    }

    if (!email.contains('@') || !email.contains('.')) {
      throw const ValidationException('Invalid email format');
    }

    if (password.isEmpty) {
      throw const ValidationException('Password cannot be empty');
    }

    if (password.length < 8) {
      throw const ValidationException('Password must be at least 8 characters');
    }

    return repository.login(email: email, password: password);
  }
}
