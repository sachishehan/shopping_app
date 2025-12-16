import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Set login status
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  // Logout - clear login status
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }
}

