import 'package:dio/dio.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login({
    required String email,
    required String password,
    CancelToken? cancelToken,
  });

  Future<UserModel> signup({
    required String email,
    required String password,
    required String fullName,
    CancelToken? cancelToken,
  });

  Future<void> logout({
    CancelToken? cancelToken,
  });

  /// Refresh the current session using stored refresh token.
  ///
  /// Throws [AuthException] if refresh token is missing or invalid.
  Future<void> refreshSession();
}
