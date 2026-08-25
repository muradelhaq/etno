import 'package:shared_preferences/shared_preferences.dart';

class StudentSessionStore {
  static const _refreshTokenKey = 'student_anonymous_refresh_token_v1';
  static SharedPreferences? _preferences;

  static void initialize(SharedPreferences preferences) {
    _preferences = preferences;
  }

  static String? get refreshToken => _preferences?.getString(_refreshTokenKey);

  static Future<void> saveRefreshToken(String refreshToken) async {
    await _preferences?.setString(_refreshTokenKey, refreshToken);
  }

  static Future<void> clear() async {
    await _preferences?.remove(_refreshTokenKey);
  }
}
