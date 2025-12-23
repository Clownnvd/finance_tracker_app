import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'auth_state.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/sign_up.dart';
import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';

class AuthCubit extends Cubit<AuthState> {
  final Login _login;
  final Signup _signup;
  final Logger _logger;

  AuthCubit({
    required Login login,
    required Signup signup,
    Logger? logger,
  })  : _login = login,
        _signup = signup,
        _logger = logger ?? Logger(),
        super(AuthInitial());

  Future<void> login(String email, String password) async {
    if (state is AuthSuccess) {
      emit(AuthFailure(AppStrings.genericError));
      return;
    }

    await _runAuthAction(
      action: () => _login(email: email, password: password),
      successLog: AppStrings.login,
    );
  }

  Future<void> signup(String fullName, String email, String password) async {
    await _runAuthAction(
      action: () =>
          _signup(fullName: fullName, email: email, password: password),
      successLog: AppStrings.signUpTitle,
    );
  }

  Future<void> _runAuthAction({
    required Future<dynamic> Function() action,
    required String successLog,
  }) async {
    emit(AuthLoading());

    const maxAttempts = 2;
    var attempt = 0;

    while (true) {
      try {
        final user = await action();
        _logger.i('$successLog: ${user.email}');
        emit(AuthSuccess(user));
        return;
      } on NetworkException catch (e) {
        attempt++;
        _logger.w(e.message);
        if (attempt >= maxAttempts) {
          emit(AuthFailure(e.message));
          return;
        }
      } on TimeoutRequestException catch (e) {
        attempt++;
        _logger.w(e.message);
        if (attempt >= maxAttempts) {
          emit(AuthFailure(e.message));
          return;
        }
      } on AuthException catch (e) {
        _logger.w(e.message);
        emit(AuthFailure(e.message));
        return;
      } on AppException catch (e) {
        _logger.w(e.message);
        emit(AuthFailure(e.message));
        return;
      } catch (e, s) {
        _logger.e(AppStrings.genericError, error: e, stackTrace: s);
        emit(AuthFailure(AppStrings.genericError));
        return;
      }
    }
  }
}
