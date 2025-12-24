import 'package:finance_tracker_app/core/constants/strings.dart';
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

    if (result.requireEmailVerification) {
      throw AuthException(result.message);
    }

    final token = await remote.login(email: email, password: password);
    await sessionLocal.saveAccessToken(token);

    return _fetchMe();
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final token = await remote.login(email: email, password: password);
      await sessionLocal.saveAccessToken(token);
      return _fetchMe();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AuthException(AppStrings.loginFailed);
    }
  }

  Future<UserModel> _fetchMe() async {
    final me = await remote.getMe();
    final meta = me['user_metadata'];

    return UserModel(
      id: (me['id'] ?? '').toString(),
      email: (me['email'] ?? '').toString(),
      fullName: meta is Map<String, dynamic> ? meta['full_name'] as String? : null,
    );
  }

  @override
  Future<void> logout() => sessionLocal.clear();
}
