// lib/core/constants/app_config.dart

/// Global application configuration & limits.
///
/// Do NOT put colors or spacing here.
/// Use for:
/// - retry counts
/// - delays
/// - common UI sizes (loader, auth images)
class AppConfig {
  const AppConfig._();

  // =======================
  // Auth / Retry
  // =======================
  static const int maxRetryAttempts = 2;

  // =======================
  // Auth UI
  // =======================
  static const double authImageWidth = 240;
  static const double authImageHeight = 120;

  static const double loaderSize = 20;
  static const double loaderStrokeWidth = 2;

  // =======================
  // UX delays
  // =======================
  /// Delay to keep success snackbar visible before navigating back.
  static const int successSnackDelayMs = 800;
}
