import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized application logger.
///
/// Features:
/// - Environment-based log level
/// - Structured tags ([AUTH], [NETWORK], [REPO], ...)
/// - Pretty output in debug
/// - Minimal noise in production
class AppLogger {
  AppLogger._();

  static Logger? _logger;

  /// Singleton logger instance
  static Logger get instance {
    _logger ??= Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 100,
        colors: kDebugMode,
        printEmojis: true,
        printTime: true,
      ),
      level: kDebugMode ? Level.debug : Level.warning,
      filter: _AppLogFilter(),
    );
    return _logger!;
  }

  // =======================
  // Domain-specific helpers
  // =======================

  static void auth(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    instance.i(
      '[AUTH] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void network(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    instance.w(
      '[NETWORK] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void repository(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    instance.d(
      '[REPO] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    instance.e(
      '[ERROR] $message',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Custom filter to silence logs in production.
///
/// Debug: log everything  
/// Release: only warning & error
class _AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kDebugMode) return true;
    return event.level.index >= Level.warning.index;
  }
}
