import 'package:dio/dio.dart';
import 'package:finance_tracker_app/core/error/exception_mapper.dart';
import 'package:finance_tracker_app/core/network/supabase_endpoints.dart';

class SignUpResult {
  final bool emailConfirmationRequired;
  final String? message;

  const SignUpResult({
    required this.emailConfirmationRequired,
    this.message,
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

      // Supabase thường trả user/session (tuỳ settings)
      // Nếu bật email confirm, thường session = null => yêu cầu verify email
      final data = res.data;
      final session = (data is Map<String, dynamic>) ? data['session'] : null;

      final requiresConfirm = session == null;

      return SignUpResult(
        emailConfirmationRequired: requiresConfirm,
        message: requiresConfirm
            ? 'Sign up successful. Please verify your email before logging in.'
            : 'Sign up successful.',
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
        queryParameters: {'grant_type': 'password'},
        data: {'email': email, 'password': password},
      );

      final json = res.data as Map<String, dynamic>;
      final token = (json['access_token'] ?? '').toString();

      if (token.isEmpty) {
        throw ExceptionMapper.map(
          DioException(
            requestOptions: res.requestOptions,
            response: res,
            error: 'Missing access_token',
            type: DioExceptionType.badResponse,
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
      return res.data as Map<String, dynamic>;
    } catch (e) {
      throw ExceptionMapper.map(e);
    }
  }
}
