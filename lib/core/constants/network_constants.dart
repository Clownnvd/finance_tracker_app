// lib/core/constants/network_constants.dart

/// Network-related constants (timeouts, retries, etc).
///
/// Keep this file limited to networking parameters.
/// Do NOT put base URLs here if you plan to use flavors/env.
/// Prefer env-based URLs and only keep stable timeouts here.
class NetworkConstants {
  const NetworkConstants._(); // Prevent instantiation

  /// Timeout for establishing a connection.
  static const int connectTimeoutSeconds = 30;

  /// Timeout for receiving data from server.
  static const int receiveTimeoutSeconds = 30;

  /// Timeout for sending data to server.
  static const int sendTimeoutSeconds = 30;
}
