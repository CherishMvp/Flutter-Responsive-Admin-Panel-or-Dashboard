// 封装shared_preferences
import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  static SharedPreferences? _instance;

  static Future<SharedPreferences> getInstance() async {
    if (_instance == null) {
      _instance = await SharedPreferences.getInstance();
    }
    return _instance!;
  }
}

class CacheKey {
  static const String token = 'token';
  static const String isDBInit = 'isDBInit';
}

class CacheHelper {
  Future<void> setToken(String token) async {
    final prefs = await LocalCache.getInstance();
    await prefs.setString(CacheKey.token, token);
  }

  Future<String?> getToken() async {
    final prefs = await LocalCache.getInstance();
    return prefs.getString(CacheKey.token);
  }

  // 是否初始化
  Future<bool> isDBInit() async {
    final prefs = await LocalCache.getInstance();
    return prefs.getBool(CacheKey.isDBInit) ?? false;
  }

  Future<void> setDBInit(bool isInit) async {
    final prefs = await LocalCache.getInstance();
    await prefs.setBool(CacheKey.isDBInit, isInit);
  }
}
