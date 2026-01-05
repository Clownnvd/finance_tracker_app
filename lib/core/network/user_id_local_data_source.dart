import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class UserIdLocalDataSource {
  Future<void> saveUserId(String uid);
  Future<String?> getUserId();
  Future<void> clear();
}

class UserIdLocalDataSourceSecure implements UserIdLocalDataSource {
  static const _kUserId = 'user_id';

  final FlutterSecureStorage _storage;

  UserIdLocalDataSourceSecure({FlutterSecureStorage? storage})
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
  Future<void> saveUserId(String uid) async {
    await _storage.write(key: _kUserId, value: uid);
  }

  @override
  Future<String?> getUserId() async {
    return _storage.read(key: _kUserId);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _kUserId);
  }
}
