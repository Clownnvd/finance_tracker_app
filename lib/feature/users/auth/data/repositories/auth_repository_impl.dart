import 'package:finance_tracking_app/core/base/base_repository.dart';
import 'package:finance_tracking_app/core/base/base_response.dart';
import 'package:finance_tracking_app/feature/users/auth/data/models/auth_remote_data_source.dart';
import '../../domain/entities/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final BaseResponse<UserModel> res = await safeCall(
      () => remote.login(email: email, password: password),
    );

    if (!res.isSuccess) {
      throw Exception(res.error);
    }
    return res.data!;
  }

  @override
  Future<UserModel> signup({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final BaseResponse<UserModel> res = await safeCall(
      () => remote.signup(
        email: email,
        password: password,
        fullName: fullName,
      ),
    );

    if (!res.isSuccess) {
      throw Exception(res.error);
    }
    return res.data!;
  }

  @override
  Future<void> logout() => remote.logout();
}
