import 'package:altitude/core/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences _prefs;

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs;

    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  Future<bool> setVersion(int version) async {
    SharedPreferences sf = await prefs;
    return await sf.setInt(VERSION, version);
  }

  Future<int> getVersion() async {
    SharedPreferences sf = await prefs;
    int version = sf.getInt(VERSION);
    return version == null ? 0 : version;
  }

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

  Future<bool> setLevel(int level) async {
    SharedPreferences sf = await prefs;
    return await sf.setInt(LEVEL, level);
  }

  Future<int> getLevel() async {
    SharedPreferences sf = await prefs;
    int level = sf.getInt(LEVEL);
    return level == null ? 0 : level;
  }

  Future<bool> setColor(int r, int g, int b) async {
    SharedPreferences sf = await prefs;
    return await sf.setString(COLOR, "$r,$g,$b");
  }

  Future<String> getColor() async {
    SharedPreferences sf = await prefs;
    return sf.getString(COLOR);
  }

  Future<bool> setPendingFriends(bool value) async {
    SharedPreferences sf = await prefs;
    return await sf.setBool(PENDING_FRIENDS, value);
  }

  Future<bool> getPendingFriends() async {
    SharedPreferences sf = await prefs;
    bool value = sf.getBool(PENDING_FRIENDS);
    return value == null ? false : value;
  }

  Future<bool> setPendingCompetitions(bool value) async {
    SharedPreferences sf = await prefs;
    return await sf.setBool(COMPETITION_FRIENDS, value);
  }

  Future<bool> getPendingCompetitions() async {
    SharedPreferences sf = await prefs;
    bool value = sf.getBool(COMPETITION_FRIENDS);
    return value == null ? false : value;
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

  Future<bool> setCompetitionTutorial(bool value) async {
    SharedPreferences sf = await prefs;
    return await sf.setBool(COMPETITION_TUTORIAL, value);
  }

  Future<bool> getCompetitionTutorial() async {
    SharedPreferences sf = await prefs;
    bool value = sf.getBool(COMPETITION_TUTORIAL);
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

  Future<bool> setAlarmTutorial() async {
    SharedPreferences sf = await prefs;
    int currentAlarm = await getAlarmTutorial();
    return await sf.setInt(ALARM_ON_DETAILS_PAGE, 1 + currentAlarm);
  }

  Future<int> getAlarmTutorial() async {
    SharedPreferences sf = await prefs;
    int value = sf.getInt(ALARM_ON_DETAILS_PAGE);
    return value == null ? 0 : value;
  }
}
