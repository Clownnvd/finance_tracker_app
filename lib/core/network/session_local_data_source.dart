import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SessionLocalDataSource {
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> clear();
}

/// Secure storage implementation.
/// - Android: EncryptedSharedPreferences (API 23+) nếu bật encryptedSharedPreferences
/// - iOS: Keychain
class SessionLocalDataSourceSecure implements SessionLocalDataSource {
  static const _kAccessToken = 'access_token';

  final FlutterSecureStorage _storage;

  SessionLocalDataSourceSecure({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
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
  Future<void> clear() async {
    await _storage.delete(key: _kAccessToken);
    // hoặc deleteAll() nếu bạn lưu nhiều keys session
    // await _storage.deleteAll();
  }
}
