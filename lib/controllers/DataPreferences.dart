import 'package:shared_preferences/shared_preferences.dart';

class DataPreferences {
  static final DataPreferences _singleton = new DataPreferences._internal();

  static SharedPreferences _prefs;

  factory DataPreferences() {
    return _singleton;
  }

  DataPreferences._internal();

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs;

    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  static String NAME = "USER_NAME";
  static String SCORE = "USER_SCORE";

  Future<bool> setName(String name) async {
    SharedPreferences sf = await prefs;

    return await sf.setString(NAME, name);
  }

  Future<String> getName() async {
    SharedPreferences sf = await prefs;

    return sf.getString(NAME);
  }

  Future<bool> setScore(int score) async {
    SharedPreferences sf = await prefs;
    int currentScore = await getScore();

    return await sf.setInt(SCORE, currentScore + score);
  }

  Future<int> getScore() async {
    SharedPreferences sf = await prefs;
    int score = sf.getInt(SCORE);

    return score == null ? 0 : score;
  }
}
