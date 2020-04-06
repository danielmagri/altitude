import 'package:altitude/common/constant/SharedPrefKeys.dart';
import 'package:altitude/core/handler/SharedPrefHandler.dart';
import 'package:get_it/get_it.dart';

class SharedPref extends SharedPrefHandler {
  static SharedPref get instance => GetIt.I.get<SharedPref>();

  static Future<SharedPref> initialize() async {
    SharedPref instance = SharedPref();
    await instance.init();
    return instance;
  }

  // Version
  int get version => getInt(VERSION) ?? 0;
  set version(int value) => saveInt(VERSION, value);

  // Name
  String get name => getString(NAME);
  set name(String value) => saveString(NAME, value);

  // Score
  int get score => getInt(SCORE) ?? 0;
  void addscore(int value) => saveInt(SCORE, score + value);

  // Level
  int get level => getInt(LEVEL) ?? 0;
  set level(int value) => saveInt(LEVEL, value);

  // Pending Friends
  bool get pendingFriends => getBool(PENDING_FRIENDS) ?? false;
  set pendingFriends(bool value) => saveBool(PENDING_FRIENDS, value);

  // Pending Friends
  bool get pendingCompetition => getBool(COMPETITION_FRIENDS) ?? false;
  set pendingCompetition(bool value) => saveBool(COMPETITION_FRIENDS, value);

  // Habit Tutorial
  bool get habitTutorial => getBool(HABIT_TUTORIAL) ?? false;
  set habitTutorial(bool value) => saveBool(HABIT_TUTORIAL, value);

  // Competition Tutorial
  bool get competitionTutorial => getBool(COMPETITION_TUTORIAL) ?? false;
  set competitionTutorial(bool value) => saveBool(COMPETITION_TUTORIAL, value);

  // Rocket Tutorial
  bool get rocketTutorial => getBool(ROCKET_ON_DETAILS_PAGE) ?? false;
  set rocketTutorial(bool value) => saveBool(ROCKET_ON_DETAILS_PAGE, value);

  // Alarm Tutorial
  int get alarmTutorial => getInt(ALARM_ON_DETAILS_PAGE) ?? 0;
  void addAlarmTutorial() => saveInt(ALARM_ON_DETAILS_PAGE, alarmTutorial + 1);
}