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
    return repository.signup(
      email: email,
      password: password,
      fullName: fullName,
    );
  }
}
