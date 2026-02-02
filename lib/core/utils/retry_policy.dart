import 'dart:math';

import 'package:dio/dio.dart';
import 'package:finance_tracker_app/core/constants/app_config.dart';
import 'package:finance_tracker_app/core/error/exceptions.dart';

/// Determines retry behavior for network operations.
///
/// Only transient errors (timeout, connection issues) should be retried.
/// Client errors (4xx) and server errors (5xx) should NOT be retried
/// as they indicate a problem that won't resolve by retrying.
class RetryPolicy {
  const RetryPolicy._();

  /// Determines if the given error is retryable.
  ///
  /// Retryable errors:
  /// - Connection timeout
  /// - Send/receive timeout
  /// - Connection errors (no internet, DNS failure)
  /// - [TimeoutRequestException]
  /// - [NetworkException]
  ///
  /// Non-retryable errors:
  /// - HTTP 4xx (client errors - bad request, unauthorized, etc.)
  /// - HTTP 5xx (server errors)
  /// - [AuthException], [ValidationException], [ServerException]
  /// - Cancelled requests
  static bool shouldRetry(Object error) {
    // Timeout exceptions are always retryable
    if (error is TimeoutRequestException) return true;

    // Network exceptions (no connection) are retryable
    if (error is NetworkException) return true;

    // DioException - only retry connection/timeout issues
    if (error is DioException) {
      // Never retry cancelled requests
      if (CancelToken.isCancel(error)) return false;

      // Only retry transient connection issues
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          return true;

        // Don't retry HTTP errors (4xx, 5xx) or other issues
        case DioExceptionType.badResponse:
        case DioExceptionType.badCertificate:
        case DioExceptionType.cancel:
        case DioExceptionType.unknown:
          return false;
      }
    }

    // AppException subclasses are NOT retryable (already mapped errors)
    if (error is AppException) return false;

    // Unknown errors - don't retry
    return false;
  }

  /// Calculates backoff delay with exponential growth, cap, and jitter.
  ///
  /// Formula: min(base * 2^attempt, maxDelay) * (1 ± jitter)
  ///
  /// Example with defaults (base=1000ms, max=16000ms, jitter=0.3):
  /// - Attempt 1: ~1000ms (± 300ms)
  /// - Attempt 2: ~2000ms (± 600ms)
  /// - Attempt 3: ~4000ms (± 1200ms)
  /// - Attempt 4: ~8000ms (± 2400ms)
  /// - Attempt 5+: ~16000ms (capped, ± 4800ms)
  static Duration calculateBackoff(int attempt, {Random? random}) {
    final rng = random ?? Random();

    // Exponential: base * 2^(attempt-1)
    final exponentialMs =
        AppConfig.backoffBaseDelayMs * pow(2, attempt - 1).toInt();

    // Cap at max delay
    final cappedMs = min(exponentialMs, AppConfig.backoffMaxDelayMs);

    // Add jitter: random value between -jitter and +jitter
    final jitterMultiplier =
        1.0 + (rng.nextDouble() * 2 - 1) * AppConfig.backoffJitterFactor;

    final finalMs = (cappedMs * jitterMultiplier).toInt();

    // Ensure minimum 100ms delay
    return Duration(milliseconds: max(100, finalMs));
  }
}
