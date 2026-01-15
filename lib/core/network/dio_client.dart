import 'package:dio/dio.dart';
import 'package:finance_tracker_app/core/constants/network_constants.dart';

/// Provides the current access token for authenticated requests.
///
/// Returns:
/// - A valid access token if the user is logged in
/// - `null` if no token is available
typedef TokenProvider = Future<String?> Function();

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

  /// Creates a configured [DioClient].
  ///
  /// [baseUrl] - Supabase project base URL
  /// [anonKey] - Supabase anonymous public API key (used for `apikey` header)
  /// [tokenProvider] - Async function that returns the current access token
  DioClient({
    required String baseUrl,
    required String anonKey,
    required TokenProvider tokenProvider,
  }) : dio = Dio(
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
          final token = await tokenProvider();
          final hasToken = token != null && token.trim().isNotEmpty;

          if (hasToken) {
            options.headers['Authorization'] = 'Bearer ${token!.trim()}';
          } else {
            options.headers.remove('Authorization');
          }

          handler.next(options);
        },

        /// Passes through errors without modification.
        ///
        /// Error mapping and handling should be done at a higher layer
        /// (e.g. data source or repository).
        onError: (e, handler) => handler.next(e),
      ),
    );
  }
}
