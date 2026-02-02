import 'dart:async';

import 'package:finance_tracker_app/core/di/di.dart';
import 'package:finance_tracker_app/core/network/session_local_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/domain/repositories/auth_repository.dart';

/// Handles token refresh with mutex to prevent concurrent refresh calls.
///
/// When multiple requests fail with 401 simultaneously, only one refresh
/// will be executed and all waiting requests will receive the result.
class TokenRefresher {
  /// Use lazy injection to avoid circular dependency:
  /// TokenRefresher -> AuthRepository -> Dio -> DioClient -> TokenRefresher
  AuthRepository get _authRepo => getIt<AuthRepository>();
  SessionLocalDataSource get _sessionLocal => getIt<SessionLocalDataSource>();

  /// Completer used as mutex for concurrent refresh requests.
  Completer<void>? _refreshCompleter;

  /// Attempts to refresh the session.
  ///
  /// If a refresh is already in progress, waits for it to complete.
  /// Returns normally on success, throws on failure.
  Future<void> refresh() async {
    // If already refreshing, wait for the existing refresh to complete
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<void>();

    try {
      await _authRepo.refreshSession();
      _refreshCompleter!.complete();
    } catch (e) {
      _refreshCompleter!.completeError(e);
      rethrow;
    } finally {
      _refreshCompleter = null;
    }
  }

  /// Clears all session data.
  ///
  /// Called when refresh fails and user needs to re-authenticate.
  Future<void> clearSession() async {
    await _sessionLocal.clear();
  }
}
