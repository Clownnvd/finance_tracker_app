import 'package:finance_tracker_app/feature/users/auth/domain/repositories/auth_repository.dart';

class Logout {
  Logout(this.repository);

  final AuthRepository repository;

  Future<void> call() => repository.logout();
}
