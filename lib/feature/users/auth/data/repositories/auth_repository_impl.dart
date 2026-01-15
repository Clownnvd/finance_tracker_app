import 'package:dio/dio.dart';
import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/network/session_local_data_source.dart';
import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/data/models/auth_remote_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final SessionLocalDataSource sessionLocal;
  final UserIdLocalDataSource userIdLocal;

  AuthRepositoryImpl({
    required this.remote,
    required this.sessionLocal,
    required this.userIdLocal,
  });

  @override
  Future<UserModel> signup({
    required String email,
    required String password,
    required String fullName,
    CancelToken? cancelToken,
  }) async {
    final result = await remote.signup(
      fullName: fullName,
      email: email,
      password: password,
      cancelToken: cancelToken,
    );

    // If backend requires email verification, do NOT auto-login.
    if (result.requireEmailVerification) {
      throw AuthException(result.message);
    }

    // Auto-login after sign up
    final token = await remote.login(
      email: email,
      password: password,
      cancelToken: cancelToken,
    );

    await sessionLocal.saveAccessToken(token);

    final user = await _fetchMe(cancelToken: cancelToken);

    // ✅ Save user id for other features (Dashboard uses this)
    if (user.id.isNotEmpty) {
      await userIdLocal.saveUserId(user.id);
    }

    return user;
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) async {
    try {
      final token = await remote.login(
        email: email,
        password: password,
        cancelToken: cancelToken,
      );

      await sessionLocal.saveAccessToken(token);

      final user = await _fetchMe(cancelToken: cancelToken);

      // ✅ Save user id for Dashboard/RPC calls
      if (user.id.isNotEmpty) {
        await userIdLocal.saveUserId(user.id);
      }

      return user;
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw const AuthException(AppStrings.loginFailed);
    } catch (_) {
      throw const AuthException(AppStrings.loginFailed);
    }
  }

  Future<UserModel> _fetchMe({CancelToken? cancelToken}) async {
    final me = await remote.getMe(cancelToken: cancelToken);
    final meta = me['user_metadata'];

    return UserModel(
      id: (me['id'] ?? '').toString(),
      email: (me['email'] ?? '').toString(),
      fullName: meta is Map<String, dynamic> ? meta['full_name'] as String? : null,
    );
  }

  @override
  Future<void> logout({CancelToken? cancelToken}) async {
    await sessionLocal.clear();
    await userIdLocal.clear(); // ✅ clear user id too
  }
}
