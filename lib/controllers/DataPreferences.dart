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

  // User data
  static const String NAME = "USER_NAME";
  static const String SCORE = "USER_SCORE";
  // Tutorials
  static const String HABIT_TUTORIAL = "HABIT_TUTORIAL";
  static const String ROCKET_ON_DETAILS_PAGE = "ROCKET_ON_DETAILS_PAGE";

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

  Future<bool> setHabitTutorial(bool value) async {
    SharedPreferences sf = await prefs;
    return await sf.setBool(HABIT_TUTORIAL, value);
  }

  Future<bool> getHabitTutorial() async {
    SharedPreferences sf = await prefs;
    bool value = sf.getBool(HABIT_TUTORIAL);
    return value == null ? false : value;
  }

  Future<bool> setRocketTutorial(bool value) async {
    SharedPreferences sf = await prefs;
    return await sf.setBool(ROCKET_ON_DETAILS_PAGE, value);
  }

  Future<bool> getRocketTutorial() async {
    SharedPreferences sf = await prefs;
    bool value = sf.getBool(ROCKET_ON_DETAILS_PAGE);
    return value == null ? false : value;
  }
}
