import 'package:shared_preferences/shared_preferences.dart';
import 'db/db_data.dart';

class SharedPref {
  static const String _isAuthenticated = 'services_auth_user_434534';
  static const String _accessTokenKey = 'services_access_token_543533';

  static Future<void> setAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  static Future<String?> get accessToken async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Authentication status
  static Future<bool> get isAuth async {
    try {
      final pref = await SharedPreferences.getInstance();
      return pref.getBool(_isAuthenticated) ?? false;
    } catch (e) {
      return false;
    }
  }

  static set setAuth(bool value) {
    SharedPreferences.getInstance().then(
      (pref) => pref.setBool(_isAuthenticated, value),
    );
  }

  static void get clear => SharedPreferences.getInstance().then((pref) {
        for (final e in [
          _isAuthenticated,
          _accessTokenKey,
        ]) {
          pref.remove(e);
        }
      });

  static void get clearAll =>
      SharedPreferences.getInstance().then((pref) async {
        await DbLocalData.removeUserInfo();
        for (final e in [
          _isAuthenticated,
          _accessTokenKey,
        ]) {
          pref.remove(e);
        }
      });
}
