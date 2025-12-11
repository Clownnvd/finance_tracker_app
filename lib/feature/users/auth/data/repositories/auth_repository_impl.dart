import 'package:finance_tracker_app/core/base/base_repository.dart';
import 'package:finance_tracker_app/core/base/base_response.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/feature/users/auth/data/models/auth_remote_data_source.dart';

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

    if (res.hasError) {
      // Rethrow đúng loại AppException (AuthException / NetworkException / ...)
      throw res.error!;
    }

    return res.requireData;
  }

  @override
  Future<UserModel> signup({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final BaseResponse<UserModel> res = await safeCall(
      () => remote.signup(email: email, password: password, fullName: fullName),
    );

    if (res.hasError) {
      throw res.error!;
    }

    return res.requireData;
  }

  @override
  Future<void> logout() async {
    final res = await safeCall<void>(() => remote.logout());

    if (res.hasError) {
      throw res.error!;
    }
  }
}
