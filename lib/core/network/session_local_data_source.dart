import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SessionLocalDataSource {
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();

  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();

  Future<void> saveExpiresAt(int epochSeconds);
  Future<int?> getExpiresAt();

  Future<void> clear();
}

/// Secure storage implementation.
/// - Android: EncryptedSharedPreferences (API 23+) nếu bật encryptedSharedPreferences
/// - iOS: Keychain
class SessionLocalDataSourceSecure implements SessionLocalDataSource {
  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kExpiresAt = 'expires_at';

  final FlutterSecureStorage _storage;

  SessionLocalDataSourceSecure({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  @override
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _kAccessToken, value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    return _storage.read(key: _kAccessToken);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _kRefreshToken, value: token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _kRefreshToken);
  }

  @override
  Future<void> saveExpiresAt(int epochSeconds) async {
    await _storage.write(key: _kExpiresAt, value: epochSeconds.toString());
  }

  @override
  Future<int?> getExpiresAt() async {
    final value = await _storage.read(key: _kExpiresAt);
    return value != null ? int.tryParse(value) : null;
  }

  @override
  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _kAccessToken),
      _storage.delete(key: _kRefreshToken),
      _storage.delete(key: _kExpiresAt),
    ]);
  }
}
