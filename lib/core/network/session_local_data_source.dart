import 'package:shared_preferences/shared_preferences.dart';

abstract class SessionLocalDataSource {
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> clear();
}

class SessionLocalDataSourcePrefs implements SessionLocalDataSource {
  static const _kAccessToken = 'access_token';

  Future<SharedPreferences> get _prefs =>
      SharedPreferences.getInstance();

  @override
  Future<void> saveAccessToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(_kAccessToken, token);
  }

  @override
  Future<String?> getAccessToken() async {
    final prefs = await _prefs;
    return prefs.getString(_kAccessToken);
  }

  @override
  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.remove(_kAccessToken);
  }
}
