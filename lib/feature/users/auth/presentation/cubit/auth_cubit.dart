import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/sign_up.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Login _login;
  final Signup _signup;

  AuthCubit({required Login login, required Signup signup})
      : _login = login,
        _signup = signup,
        super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _login(email: email, password: password);
      log('Login success: ${user.email}', name: 'AuthCubit');
      emit(AuthSuccess(user));
    } catch (e) {
      log('Login error: $e', name: 'AuthCubit');
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signup(String fullName, String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _signup(
        fullName: fullName,
        email: email,
        password: password,
      );
      log('Signup success: ${user.email}', name: 'AuthCubit');
      emit(AuthSuccess(user));
    } catch (e) {
      log('Signup error: $e', name: 'AuthCubit');
      emit(AuthFailure(e.toString()));
    }
  }
}
