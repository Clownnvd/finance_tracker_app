import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/network/session_local_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/data/models/auth_remote_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final SessionLocalDataSource sessionLocal;

  AuthRepositoryImpl({
    required this.remote,
    required this.sessionLocal,
  });

  @override
  Future<UserModel> signup({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final result = await remote.signup(
      fullName: fullName,
      email: email,
      password: password,
    );

    // ✅ Bật email confirm => không login ngay
    if (result.emailConfirmationRequired) {
      throw AuthException(
        result.message ??
            'Sign up successful. Please verify your email before logging in.',
      );
    }

    // Nếu project bạn tắt confirm email (session có sẵn) thì có thể auto login:
    final token = await remote.login(email: email, password: password);
    await sessionLocal.saveAccessToken(token);

    final me = await remote.getMe();
    return UserModel.fromJson({
      'id': me['id'],
      'email': me['email'],
      'fullName': (me['user_metadata']?['full_name']) as String?,
    });
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final token = await remote.login(email: email, password: password);
    await sessionLocal.saveAccessToken(token);

    final me = await remote.getMe();
    return UserModel(
      id: (me['id'] ?? '').toString(),
      email: (me['email'] ?? '').toString(),
      fullName: (me['user_metadata']?['full_name']) as String?,
    );
  }

  @override
  Future<void> logout() async {
    await sessionLocal.clear();
  }
}
