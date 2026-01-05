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

  Future<String> login({
    required String email,
    required String password,
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
  Future<String> login({
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) {
    return _guard(() async {
      final res = await dio.post(
        SupabaseEndpoints.authToken,
        queryParameters: const {'grant_type': 'password'},
        data: {'email': email, 'password': password},
        cancelToken: cancelToken,
      );

      final data = res.data;
      final token = data is Map<String, dynamic>
          ? (data['access_token'] ?? '').toString().trim()
          : '';

      if (token.isEmpty) {
        throw const ServerException(AppStrings.genericError);
      }

      return token;
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
