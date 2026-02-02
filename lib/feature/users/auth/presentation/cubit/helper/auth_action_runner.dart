import 'package:dio/dio.dart';

import 'package:finance_tracker_app/core/constants/app_config.dart';
import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';
import 'package:finance_tracker_app/core/utils/app_logger.dart';
import 'package:finance_tracker_app/core/utils/retry_policy.dart';

/// Runs an async action with retry logic for transient errors.
///
/// Uses [RetryPolicy] to determine:
/// - Which errors are retryable (timeout, network issues)
/// - Backoff delay with exponential growth, cap, and jitter
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
        // Handle cancelled requests immediately
        if (CancelToken.isCancel(e)) {
          onCancelled();
          return;
        }

        attempt++;
        AppLogger.network(
          '$label DioException (attempt $attempt/$maxAttempts)',
          error: e,
        );

        // Check if this error type is retryable
        if (!RetryPolicy.shouldRetry(e) || attempt >= maxAttempts) {
          onFailure(_extractMessage(e));
          return;
        }

        await _backoff(attempt);
      } on AppException catch (e) {
        // AppException (Auth, Validation, Server, etc.) - check if retryable
        attempt++;

        if (e is TimeoutRequestException || e is NetworkException) {
          AppLogger.network(
            '$label ${e.runtimeType} (attempt $attempt/$maxAttempts)',
            error: e,
          );

          if (attempt >= maxAttempts) {
            onFailure(e.message);
            return;
          }

          await _backoff(attempt);
        } else {
          // Non-retryable AppException (Auth, Validation, Server)
          AppLogger.auth('$label failed', error: e);
          onFailure(e.message);
          return;
        }
      } catch (e, s) {
        // Unknown errors - don't retry
        AppLogger.error('$label unexpected error', error: e, stackTrace: s);
        onFailure(AppStrings.genericError);
        return;
      }
    }
  }

  /// Calculates and applies backoff delay using [RetryPolicy].
  Future<void> _backoff(int attempt) async {
    final delay = RetryPolicy.calculateBackoff(attempt);
    final delayMs = delay.inMilliseconds;
    AppLogger.network('Retrying in ${delayMs}ms...');
    await Future.delayed(delay);
  }

  /// Extracts user-friendly message from DioException.
  String _extractMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return AppStrings.genericError;
    }
  }
}
