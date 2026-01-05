import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker_app/core/constants/app_config.dart';
import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/utils/app_logger.dart';

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
        super(AuthInitial());

  // =======================
  // Public API
  // =======================

  /// Executes login flow with retry, cancellation, and error handling.
  Future<void> login(String email, String password) async {
    if (state is AuthLoading) return;

    _cancelOngoing();
    _cancelToken = CancelToken();

    AppLogger.auth('Login started');

    final runner = _AuthActionRunner(
      label: AppStrings.login,
      maxAttempts: AppConfig.maxRetryAttempts,
      onLoading: () => emit(AuthLoading()),
      onSuccess: (user) => emit(AuthSuccess(user)),
      onFailure: (message) => emit(AuthFailure(message)),
      onCancelled: () {
        AppLogger.auth('${AppStrings.login} cancelled');
      },
    );

    await runner.run(() => _login(
          email: email,
          password: password,
          cancelToken: _cancelToken,
        ));
  }

  /// Executes signup flow with retry, cancellation, and error handling.
  Future<void> signup(String fullName, String email, String password) async {
    if (state is AuthLoading) return;

    _cancelOngoing();
    _cancelToken = CancelToken();

    AppLogger.auth('Signup started');

    final runner = _AuthActionRunner(
      label: AppStrings.signUpTitle,
      maxAttempts: AppConfig.maxRetryAttempts,
      onLoading: () => emit(AuthLoading()),
      onSuccess: (user) => emit(AuthSuccess(user)),
      onFailure: (message) => emit(AuthFailure(message)),
      onCancelled: () {
        AppLogger.auth('${AppStrings.signUpTitle} cancelled');
      },
    );

    await runner.run(() => _signup(
          fullName: fullName,
          email: email,
          password: password,
          cancelToken: _cancelToken,
        ));
  }

  /// Cancels any ongoing authentication request and resets state.
  void cancel() {
    AppLogger.auth('Auth flow cancelled by user');
    _cancelOngoing();
    emit(AuthInitial());
  }

  // =======================
  // Internal helpers
  // =======================

  /// Cancels the current request if it is still active.
  void _cancelOngoing() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel();
    }
    _cancelToken = null;
  }

  @override
  Future<void> close() {
    _cancelOngoing();
    return super.close();
  }
}

/// Helper responsible for executing an auth-related action with:
/// - Retry logic
/// - Exponential backoff
/// - Cancellation support
/// - Centralized error handling
class _AuthActionRunner {
  final String label;
  final int maxAttempts;

  final void Function() onLoading;
  final void Function(dynamic user) onSuccess;
  final void Function(String message) onFailure;
  final void Function() onCancelled;

  _AuthActionRunner({
    required this.label,
    required this.maxAttempts,
    required this.onLoading,
    required this.onSuccess,
    required this.onFailure,
    required this.onCancelled,
  });

  /// Runs the provided action with retry and error handling.
  Future<void> run(Future<dynamic> Function() action) async {
    onLoading();

    var attempt = 0;

    while (attempt < maxAttempts) {
      try {
        final user = await action();
        AppLogger.auth('$label success: ${user.email}');
        onSuccess(user);
        return;
      }

      // -----------------------
      // Cancellation handling
      // -----------------------
      on DioException catch (e) {
        if (CancelToken.isCancel(e)) {
          onCancelled();
          return;
        }

        AppLogger.network('$label DioException', error: e);
        attempt++;

        if (attempt >= maxAttempts) {
          onFailure(AppStrings.genericError);
          return;
        }

        await _backoff(attempt);
      }

      // -----------------------
      // Retryable domain errors
      // -----------------------
      on TimeoutRequestException catch (e) {
        attempt++;
        AppLogger.network(
          '$label timeout (attempt $attempt/$maxAttempts)',
          error: e,
        );

        if (attempt >= maxAttempts) {
          onFailure(e.message);
          return;
        }

        await _backoff(attempt);
      } on NetworkException catch (e) {
        attempt++;
        AppLogger.network(
          '$label network error (attempt $attempt/$maxAttempts)',
          error: e,
        );

        if (attempt >= maxAttempts) {
          onFailure(e.message);
          return;
        }

        await _backoff(attempt);
      }

      // -----------------------
      // Non-retryable errors
      // -----------------------
      on AppException catch (e) {
        AppLogger.auth('$label failed', error: e);
        onFailure(e.message);
        return;
      } catch (e, s) {
        AppLogger.error(
          '$label unexpected error',
          error: e,
          stackTrace: s,
        );
        onFailure(AppStrings.genericError);
        return;
      }
    }
  }

  /// Applies exponential backoff before the next retry attempt.
  Future<void> _backoff(int attempt) async {
    final seconds = pow(2, attempt).toInt();
    AppLogger.network('Retrying in $seconds seconds...');
    await Future.delayed(Duration(seconds: seconds));
  }
}
