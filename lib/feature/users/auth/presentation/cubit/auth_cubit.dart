import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/utils/app_logger.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/entities/user_model.dart';
import 'package:finance_tracker_app/feature/users/auth/presentation/cubit/helper/auth_action_runner.dart';

import '../../domain/usecases/login.dart';
import '../../domain/usecases/sign_up.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Login _login;
  final Signup _signup;

  CancelToken? _cancelToken;

  AuthCubit({
    required Login login,
    required Signup signup,
  })  : _login = login,
        _signup = signup,
        super(const AuthInitial());

  Future<void> login(String email, String password) async {
    if (state is AuthLoading) return;

    _cancelOngoing();
    _cancelToken = CancelToken();

    AppLogger.auth('Login started');

    final runner = AuthActionRunner<UserModel>(
      label: AppStrings.login,
      onAttempt: (attempt, maxAttempts) =>
          emit(AuthLoading(attempt: attempt, maxAttempts: maxAttempts)),
      onSuccess: (user) => emit(AuthSuccess(user)),
      onFailure: (message) => emit(AuthFailure(message)),
      onCancelled: () => AppLogger.auth('${AppStrings.login} cancelled'),
    );

    await runner.run(() => _login(
          email: email,
          password: password,
          cancelToken: _cancelToken,
        ));
  }

  Future<void> signup(String fullName, String email, String password) async {
    if (state is AuthLoading) return;

    _cancelOngoing();
    _cancelToken = CancelToken();

    AppLogger.auth('Signup started');

    final runner = AuthActionRunner<UserModel>(
      label: AppStrings.signUpTitle,
      onAttempt: (attempt, maxAttempts) =>
          emit(AuthLoading(attempt: attempt, maxAttempts: maxAttempts)),
      onSuccess: (user) => emit(AuthSuccess(user)),
      onFailure: (message) => emit(AuthFailure(message)),
      onCancelled: () => AppLogger.auth('${AppStrings.signUpTitle} cancelled'),
    );

    await runner.run(() => _signup(
          fullName: fullName,
          email: email,
          password: password,
          cancelToken: _cancelToken,
        ));
  }

  void cancel() {
    AppLogger.auth('Auth flow cancelled by user');
    _cancelOngoing();
    emit(const AuthInitial());
  }

  void _cancelOngoing() {
    final token = _cancelToken;
    if (token != null && !token.isCancelled) {
      token.cancel();
    }
    _cancelToken = null;
  }

  @override
  Future<void> close() {
    _cancelOngoing();
    return super.close();
  }
}
