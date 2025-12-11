import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'auth_state.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/sign_up.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';

class AuthCubit extends Cubit<AuthState> {
  final Login _login;
  final Signup _signup;
  final Logger _logger;

  AuthCubit({required Login login, required Signup signup, Logger? logger})
    : _login = login,
      _signup = signup,
      _logger = logger ?? Logger(),
      super(AuthInitial());

  Future<void> login(String email, String password) async {
    if (state is AuthSuccess) {
      emit(AuthFailure('You are already logged in.'));
      return;
    }

    await _runAuthAction(
      actionLabel: 'login',
      action: () => _login(email: email, password: password),
      successMessage: 'Login success',
    );
  }

  Future<void> signup(String fullName, String email, String password) async {
    await _runAuthAction(
      actionLabel: 'signup',
      action: () =>
          _signup(fullName: fullName, email: email, password: password),
      successMessage: 'Signup success',
    );
  }

  Future<void> _runAuthAction({
    required String actionLabel,
    required Future<dynamic> Function() action,
    required String successMessage,
  }) async {
    emit(AuthLoading());

    const maxAttempts = 2;
    var attempt = 0;

    while (true) {
      try {
        final user = await action();
        _logger.i('$successMessage: ${user.email}', error: null);
        emit(AuthSuccess(user));
        return;
      } on NetworkException catch (e) {
        attempt++;
        _logger.w(
          'NetworkException on $actionLabel attempt $attempt: ${e.message}',
        );
        if (attempt >= maxAttempts) {
          emit(AuthFailure(e.message));
          return;
        }
      } on TimeoutRequestException catch (e) {
        attempt++;
        _logger.w(
          'TimeoutRequestException on $actionLabel attempt $attempt: ${e.message}',
        );
        if (attempt >= maxAttempts) {
          emit(AuthFailure(e.message));
          return;
        }
      } on AuthException catch (e) {
        _logger.w('AuthException on $actionLabel: ${e.message}');
        emit(AuthFailure(e.message));
        return;
      } on AppException catch (e) {
        _logger.w('AppException on $actionLabel: ${e.message}');
        emit(AuthFailure(e.message));
        return;
      } catch (e, s) {
        _logger.e('Unexpected error on $actionLabel', error: e, stackTrace: s);
        emit(AuthFailure('Unexpected error. Please try again.'));
        return;
      }
    }
  }
}
