import 'package:dio/dio.dart';

import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/repositories/auth_repository.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/validators/auth_validators.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<UserModel> call({
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) async {
    // =======================
    // Unified domain validation
    // =======================
    AuthValidators.validateEmail(email);
    AuthValidators.validatePassword(password);

    // Email should be trimmed, password should NOT
    final trimmedEmail = email.trim();

    // =======================
    // Delegate to repository
    // =======================
    return repository.login(
      email: trimmedEmail,
      password: password,
      cancelToken: cancelToken,
    );
  }
}
