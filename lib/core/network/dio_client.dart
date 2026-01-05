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
/// - Automatically attach authentication headers
/// - Apply global timeouts
///
/// This client is designed to work with Supabase APIs.
class DioClient {
  /// The underlying Dio instance used for HTTP requests.
  final Dio dio;

  /// Creates a configured [DioClient].
  ///
  /// [baseUrl] - Supabase project base URL
  /// [anonKey] - Supabase anonymous public API key
  /// [tokenProvider] - Async function that returns the current access token
  ///
  /// If [tokenProvider] returns `null`, the client falls back to using
  /// the anonymous key for unauthenticated requests.
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
    // Ensure apikey is always present (Supabase requirement).
    dio.options.headers['apikey'] = anonKey;

    /// Interceptor responsible for injecting authentication headers
    /// into every outgoing request.
    dio.interceptors.add(
      InterceptorsWrapper(
        /// Attaches `Authorization` header before the request is sent.
        ///
        /// - Uses `Bearer <access_token>` when available
        /// - Falls back to `Bearer <anonKey>` for public endpoints
        onRequest: (options, handler) async {
          final token = await tokenProvider();
          options.headers['Authorization'] = 'Bearer ${token ?? anonKey}';
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
