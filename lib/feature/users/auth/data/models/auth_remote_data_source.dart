import 'package:dio/dio.dart';
import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/error/dio_exception_mapper.dart';
import 'package:finance_tracker_app/core/error/exception_mapper.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/network/supabase_endpoints.dart';

/// Result object returned after a signup request.
///
/// [requireEmailVerification] indicates whether the user must verify
/// their email before being able to log in.
/// [message] is a user-facing success message.
class SignUpResult {
  final bool requireEmailVerification;
  final String message;

  const SignUpResult({
    required this.requireEmailVerification,
    required this.message,
  });
}

/// Token response from Supabase Auth.
///
/// Contains both access and refresh tokens for session management.
class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final int expiresAt; // epoch seconds

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  /// Parse from Supabase auth response JSON.
  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    final accessToken = (json['access_token'] ?? '').toString().trim();
    final refreshToken = (json['refresh_token'] ?? '').toString().trim();
    final expiresAt = json['expires_at'] as int? ?? 0;

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }

  bool get isValid => accessToken.isNotEmpty && refreshToken.isNotEmpty;
}

/// Contract for authentication-related remote operations.
///
/// This data source communicates directly with Supabase Auth APIs.
abstract class AuthRemoteDataSource {
  Future<SignUpResult> signup({
    required String fullName,
    required String email,
    required String password,
    CancelToken? cancelToken,
  });

  Future<AuthTokens> login({
    required String email,
    required String password,
    CancelToken? cancelToken,
  });

  /// Refresh session using refresh token.
  ///
  /// Returns new [AuthTokens] if successful.
  Future<AuthTokens> refreshToken({
    required String refreshToken,
    CancelToken? cancelToken,
  });

  Future<Map<String, dynamic>> getMe({
    CancelToken? cancelToken,
  });
}

/// Dio-based implementation of [AuthRemoteDataSource].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  /// Guards API calls and centralizes error mapping.
  ///
  /// Important: if request is cancelled, rethrow DioException so upper layers
  /// can ignore cancel (do NOT map it into AppException).
  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw DioExceptionMapper.map(e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<SignUpResult> signup({
    required String fullName,
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) {
    return _guard(() async {
      final res = await dio.post(
        SupabaseEndpoints.authSignUp,
        data: {
          'email': email,
          'password': password,
          'data': {'full_name': fullName},
        },
        cancelToken: cancelToken,
      );

      final body = res.data;
      final session = body is Map<String, dynamic> ? body['session'] : null;

      final requireEmailVerification = session == null;

      return SignUpResult(
        requireEmailVerification: requireEmailVerification,
        message: requireEmailVerification
            ? AppStrings.signUpSuccessVerifyEmail
            : AppStrings.signUpSuccess,
      );
    });
  }

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) {
    return _guard(() async {
      final res = await dio.post(
        SupabaseEndpoints.authTokenPassword,
        data: {'email': email, 'password': password},
        cancelToken: cancelToken,
      );

      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw const ServerException(AppStrings.genericError);
      }

      final tokens = AuthTokens.fromJson(data);
      if (!tokens.isValid) {
        throw const ServerException(AppStrings.genericError);
      }

      return tokens;
    });
  }

  @override
  Future<AuthTokens> refreshToken({
    required String refreshToken,
    CancelToken? cancelToken,
  }) {
    return _guard(() async {
      final res = await dio.post(
        SupabaseEndpoints.authTokenRefresh,
        data: {'refresh_token': refreshToken},
        cancelToken: cancelToken,
      );

      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw const ServerException(AppStrings.genericError);
      }

      final tokens = AuthTokens.fromJson(data);
      if (!tokens.isValid) {
        throw const ServerException(AppStrings.genericError);
      }

      return tokens;
    });
  }

  @override
  Future<Map<String, dynamic>> getMe({CancelToken? cancelToken}) {
    return _guard(() async {
      final res = await dio.get(
        SupabaseEndpoints.authUser,
        cancelToken: cancelToken,
      );

      final data = res.data;
      if (data is Map<String, dynamic>) return data;

      throw const ServerException(AppStrings.genericError);
    });
  }
}
