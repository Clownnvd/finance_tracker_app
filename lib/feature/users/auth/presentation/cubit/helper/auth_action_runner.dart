import 'dart:math';

import 'package:dio/dio.dart';

import 'package:finance_tracker_app/core/constants/app_config.dart';
import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/utils/app_logger.dart';

class AuthActionRunner<T> {
  final String label;
  final int maxAttempts;

  final void Function(int attempt, int maxAttempts) onAttempt;
  final void Function(T user) onSuccess;
  final void Function(String message) onFailure;
  final void Function() onCancelled;

  AuthActionRunner({
    required this.label,
    int? maxAttempts,
    required this.onAttempt,
    required this.onSuccess,
    required this.onFailure,
    required this.onCancelled,
  }) : maxAttempts = maxAttempts ?? AppConfig.maxRetryAttempts;

  Future<void> run(Future<T> Function() action) async {
    var attempt = 0;

    while (attempt < maxAttempts) {
      final displayAttempt = attempt + 1;
      onAttempt(displayAttempt, maxAttempts);

      try {
        final user = await action();
        AppLogger.auth('$label success');
        onSuccess(user);
        return;
      } on DioException catch (e) {
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
      } on TimeoutRequestException catch (e) {
        attempt++;
        AppLogger.network('$label timeout (attempt $attempt/$maxAttempts)', error: e);

        if (attempt >= maxAttempts) {
          onFailure(e.message);
          return;
        }

        await _backoff(attempt);
      } on NetworkException catch (e) {
        attempt++;
        AppLogger.network('$label network error (attempt $attempt/$maxAttempts)', error: e);

        if (attempt >= maxAttempts) {
          onFailure(e.message);
          return;
        }

        await _backoff(attempt);
      } on AppException catch (e) {
        AppLogger.auth('$label failed', error: e);
        onFailure(e.message);
        return;
      } catch (e, s) {
        AppLogger.error('$label unexpected error', error: e, stackTrace: s);
        onFailure(AppStrings.genericError);
        return;
      }
    }
  }

  Future<void> _backoff(int attempt) async {
    final seconds = pow(2, attempt).toInt();
    AppLogger.network('Retrying in $seconds seconds...');
    await Future.delayed(Duration(seconds: seconds));
  }
}
