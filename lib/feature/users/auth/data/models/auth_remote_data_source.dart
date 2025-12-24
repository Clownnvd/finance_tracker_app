import 'package:dio/dio.dart';
import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/error/exception_mapper.dart';
import 'package:finance_tracker_app/core/network/supabase_endpoints.dart';

class SignUpResult {
  final bool requireEmailVerification;
  final String message;

  const SignUpResult({
    required this.requireEmailVerification,
    required this.message,
  });
}

abstract class AuthRemoteDataSource {
  Future<SignUpResult> signup({
    required String fullName,
    required String email,
    required String password,
  });

  Future<String> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<SignUpResult> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final res = await dio.post(
        SupabaseEndpoints.authSignUp,
        data: {
          'email': email,
          'password': password,
          'data': {'full_name': fullName},
        },
      );

      final body = res.data;
      final session = body is Map<String, dynamic> ? body['session'] : null;
      final needVerifyEmail = session == null;

      return SignUpResult(
        requireEmailVerification: needVerifyEmail,
        message: needVerifyEmail
            ? AppStrings.signUpSuccessVerifyEmail
            : AppStrings.signUpSuccessAutoLogin,
      );
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await dio.post(
        SupabaseEndpoints.authToken,
        queryParameters: const {'grant_type': 'password'},
        data: {'email': email, 'password': password},
      );

      final data = res.data;
      final token = data is Map<String, dynamic>
          ? (data['access_token'] ?? '').toString()
          : '';

      if (token.isEmpty) {
        throw ExceptionMapper.map(
          DioException(
            requestOptions: res.requestOptions,
            response: res,
            type: DioExceptionType.badResponse,
            error: AppStrings.genericError,
          ),
        );
      }

      return token;
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getMe() async {
    try {
      final res = await dio.get(SupabaseEndpoints.authUser);
      final data = res.data;

      if (data is Map<String, dynamic>) return data;

      throw ExceptionMapper.map(
        DioException(
          requestOptions: res.requestOptions,
          response: res,
          type: DioExceptionType.badResponse,
          error: AppStrings.genericError,
        ),
      );
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }
}
