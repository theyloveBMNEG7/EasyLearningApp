import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static Future<void> setLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  static Future<void> setIntroSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<bool> hasSeenIntro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenIntro') ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
  }
}
