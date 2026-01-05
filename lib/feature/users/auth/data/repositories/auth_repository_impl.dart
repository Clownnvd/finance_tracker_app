import 'package:dio/dio.dart';
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

    return _fetchMe(cancelToken: cancelToken);
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

      return _fetchMe(cancelToken: cancelToken);
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      // If request was cancelled -> bubble up so Cubit can ignore it
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
    // If you also call remote logout endpoint in the future,
    // pass cancelToken there. For now it's local only.
    await sessionLocal.clear();
  }
}
