import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefHandler {
  SharedPreferences? _prefs;

  Future<SharedPreferences?> init() async {
    if (_prefs != null) return _prefs;

    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  void saveString(String key, String value) => _prefs!.setString(key, value);

  void saveInt(String key, int value) => _prefs!.setInt(key, value);

  void saveBool(String key, bool value) => _prefs!.setBool(key, value);

  String? getString(String key) => _prefs!.getString(key);

  int? getInt(String key) => _prefs!.getInt(key);

  bool? getBool(String key) => _prefs!.getBool(key);
}
