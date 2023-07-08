import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPrefs {
  static const String isLogin = "is_logged_in";

  //set prefs value

  static Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getBool(key);
    return res ?? false;
  }

  //get set value login status
  static Future<bool> setLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(isLogin, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    var res = prefs.getBool(isLogin);
    return res ?? false;
  }
}
