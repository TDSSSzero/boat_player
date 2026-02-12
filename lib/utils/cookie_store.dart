import 'package:shared_preferences/shared_preferences.dart';

class CookieStore {
  static const String _kCookieKey = 'bili_cookies';

  static final CookieStore _instance = CookieStore._internal();
  factory CookieStore() => _instance;
  CookieStore._internal();

  String _cookie = '';
  static const String kCookie = '';
  String get cookie => _cookie;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _cookie = prefs.getString(_kCookieKey) ?? kCookie;
  }

  Future<void> saveCookie(String cookieStr) async {
    _cookie = cookieStr;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCookieKey, cookieStr);
  }

  Future<void> clearCookie() async {
    _cookie = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCookieKey);
  }

  bool get hasCookie => _cookie.isNotEmpty;
}
