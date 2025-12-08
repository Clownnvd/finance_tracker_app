import '../entities/user_model.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;
  Login(this.repository);

  Future<UserModel> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
