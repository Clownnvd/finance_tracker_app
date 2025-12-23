import 'package:shared_preferences/shared_preferences.dart';

import 'session_local_data_source.dart';

class SessionLocalDataSourcePrefs implements SessionLocalDataSource {
  static const _kAccessToken = 'access_token';

  @override
  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAccessToken, token);
  }

  @override
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAccessToken);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAccessToken);
  }
}
