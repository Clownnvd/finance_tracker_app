import '../entities/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> signup({
    required String email,
    required String password,
    required String fullName,
  });
  Future<void> logout();
}
