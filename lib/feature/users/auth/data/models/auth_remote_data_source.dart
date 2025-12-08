import 'package:finance_tracking_app/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signup({
    required String fullName,
    required String email,
    required String password,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;

  AuthRemoteDataSourceImpl({SupabaseClient? client})
      : client = client ?? Supabase.instance.client;

  @override
  Future<UserModel> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final res = await client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName, // metadata để trigger lấy xuống
      },
    );

    final user = res.user;
    if (user == null) {
      throw AppException('Signup failed');
    }

    return UserModel.fromSupabase(user);
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final res = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user == null) {
      throw AppException('Login failed');
    }
    return UserModel.fromSupabase(user);
  }

  @override
  Future<void> logout() async {
    await client.auth.signOut();
  }
}
