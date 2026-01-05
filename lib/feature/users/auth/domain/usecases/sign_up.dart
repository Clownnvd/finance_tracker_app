import 'package:dio/dio.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/repositories/auth_repository.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/validators/auth_validators.dart';

class Signup {
  final AuthRepository repository;
  Signup(this.repository);

  Future<UserModel> call({
    required String email,
    required String password,
    required String fullName,
    CancelToken? cancelToken,
  }) {
    final n = AuthValidators.validateFullName(fullName);
    final e = AuthValidators.validateEmail(email);
    AuthValidators.validatePassword(password);
    return repository.signup(email: e, password: password, fullName: n);
  }
}
