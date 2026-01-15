/// Network-related constants (timeouts, retries, etc).
class NetworkConstants {
  const NetworkConstants._(); // Prevent instantiation

  /// Timeout for establishing a connection.
  static const int connectTimeoutSeconds = 30;

  /// Timeout for receiving data from server.
  static const int receiveTimeoutSeconds = 30;

  /// Timeout for sending data to server.
  static const int sendTimeoutSeconds = 30;
}
