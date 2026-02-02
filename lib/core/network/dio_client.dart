import 'package:dio/dio.dart';
import 'package:finance_tracker_app/core/constants/network_constants.dart';
import 'package:finance_tracker_app/core/network/token_refresher.dart';

/// Provides the current access token for authenticated requests.
///
/// Returns:
/// - A valid access token if the user is logged in
/// - `null` if no token is available
typedef TokenProvider = Future<String?> Function();

/// Key used in requestOptions.extra to track retry attempts.
const _kIsRetryKey = 'is_retry';

/// Centralized HTTP client wrapper around Dio.
///
/// Responsibilities:
/// - Configure base URL and default headers
/// - Always include Supabase `apikey` header
/// - Attach `Authorization: Bearer <access_token>` only when token exists
/// - Apply global timeouts
///
/// Notes for Supabase:
/// - `apikey` is required on every request (anon key)
/// - `Authorization` should be the user JWT (access token) when logged in
/// - Do NOT use `Bearer <anonKey>` as a fallback, because anon key is not a JWT
class DioClient {
  /// The underlying Dio instance used for HTTP requests.
  final Dio dio;

  /// Token refresher instance for handling 401 errors.
  final TokenRefresher? _tokenRefresher;

  /// Token provider for getting current access token.
  final TokenProvider _tokenProvider;

  /// Creates a configured [DioClient].
  ///
  /// [baseUrl] - Supabase project base URL
  /// [anonKey] - Supabase anonymous public API key (used for `apikey` header)
  /// [tokenProvider] - Async function that returns the current access token
  /// [tokenRefresher] - Optional refresher for handling 401 errors with auto-retry
  DioClient({
    required String baseUrl,
    required String anonKey,
    required TokenProvider tokenProvider,
    TokenRefresher? tokenRefresher,
  })  : _tokenRefresher = tokenRefresher,
        _tokenProvider = tokenProvider,
        dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,

            /// Maximum duration to establish a connection
            connectTimeout: Duration(
              seconds: NetworkConstants.connectTimeoutSeconds,
            ),

            /// Maximum duration to wait for a response
            receiveTimeout: Duration(
              seconds: NetworkConstants.receiveTimeoutSeconds,
            ),

            /// Maximum duration to send request data
            sendTimeout: Duration(
              seconds: NetworkConstants.sendTimeoutSeconds,
            ),

            /// Default headers applied to all requests
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    // Supabase requires `apikey` for both public and authenticated requests.
    dio.options.headers['apikey'] = anonKey;

    /// Interceptor responsible for injecting authentication headers
    /// into every outgoing request.
    dio.interceptors.add(
      InterceptorsWrapper(
        /// Attaches `Authorization` header before the request is sent.
        ///
        /// - Uses `Bearer <access_token>` when available
        /// - Removes `Authorization` when token is missing (public requests)
        onRequest: (options, handler) async {
          final token = await _tokenProvider();

          if (token != null && token.trim().isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${token.trim()}';
          } else {
            options.headers.remove('Authorization');
          }

          handler.next(options);
        },

        /// Handles 401 errors by attempting to refresh token and retry.
        ///
        /// Flow:
        /// 1. Detect 401 Unauthorized
        /// 2. If not already retrying, attempt token refresh
        /// 3. If refresh succeeds, retry original request with new token
        /// 4. If refresh fails, clear session and propagate error
        onError: (error, handler) async {
          // Only handle 401 if we have a token refresher
          if (error.response?.statusCode != 401 || _tokenRefresher == null) {
            return handler.next(error);
          }

          // Prevent infinite retry loops
          final isRetry = error.requestOptions.extra[_kIsRetryKey] == true;
          if (isRetry) {
            return handler.next(error);
          }

          try {
            // Attempt to refresh the token
            await _tokenRefresher.refresh();

            // Get new token and retry the original request
            final newToken = await _tokenProvider();
            if (newToken != null && newToken.isNotEmpty) {
              error.requestOptions.headers['Authorization'] =
                  'Bearer ${newToken.trim()}';
            }

            // Mark as retry to prevent infinite loops
            error.requestOptions.extra[_kIsRetryKey] = true;

            // Retry the original request
            final response = await dio.fetch(error.requestOptions);
            return handler.resolve(response);
          } catch (_) {
            // Refresh failed - clear session and propagate original error
            await _tokenRefresher.clearSession();
            return handler.next(error);
          }
        },
      ),
    );
  }
}
