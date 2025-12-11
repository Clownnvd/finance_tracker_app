import 'dart:async';
import 'dart:io';

import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../domain/entities/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signup({
    required String fullName,
    required String email,
    required String password,
  });

  Future<UserModel> login({required String email, required String password});

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final sb.SupabaseClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<UserModel> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final res = await client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      final user = res.user;
      if (user != null) return UserModel.fromSupabase(user);

      throw const AuthException(
        'Sign up successful. Please verify your email.',
      );
    } on sb.AuthException catch (e) {
      throw AuthException(_mapSupabaseAuthError(e.message));
    } on SocketException {
      throw const NetworkException('No internet connection.');
    } on TimeoutException {
      throw const TimeoutRequestException();
    } catch (_) {
      throw const ServerException('Unexpected error occurred during sign up.');
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;
      final session = res.session;

      if (user == null) {
        throw const ServerException('No user returned from server.');
      }

      if (session == null) {
        throw const AuthException(
          'Your account is not active. Please verify your email.',
        );
      }

      return UserModel.fromSupabase(user);
    } on sb.AuthException catch (e) {
      throw AuthException(_mapSupabaseAuthError(e.message));
    } on SocketException {
      throw const NetworkException('No internet connection.');
    } on TimeoutException {
      throw const TimeoutRequestException();
    } catch (_) {
      throw const ServerException('Unexpected error occurred during login.');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await client.auth.signOut();
    } on sb.AuthException catch (e) {
      throw AuthException(_mapSupabaseAuthError(e.message));
    } on SocketException {
      throw const NetworkException('No internet connection.');
    } on TimeoutException {
      throw const TimeoutRequestException();
    } catch (_) {
      throw const ServerException('Unexpected error occurred during logout.');
    }
  }

  String _mapSupabaseAuthError(String message) {
    final m = message.toLowerCase();

    if (m.contains('invalid login credentials')) {
      return 'Email or password is incorrect.';
    }
    if (m.contains('user already registered') ||
        m.contains('already registered')) {
      return 'This email is already registered.';
    }
    if (m.contains('password') && m.contains('least')) {
      return 'Password is too weak.';
    }
    if (m.contains('email not confirmed')) {
      return 'Please verify your email before continuing.';
    }

    return message;
  }
}
