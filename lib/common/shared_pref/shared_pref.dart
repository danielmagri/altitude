import 'package:altitude/common/constant/SharedPrefKeys.dart';
import 'package:altitude/common/shared_pref/core/shared_pref_handler.dart';
import 'package:get_it/get_it.dart';

class SharedPref extends SharedPrefHandler {
  @deprecated
  static SharedPref get instance => GetIt.I.get<SharedPref>();

  static Future<SharedPref> initialize() async {
    SharedPref instance = SharedPref();
    await instance.init();
    return instance;
  }

  // Version
  int get version => getInt(VERSION) ?? 0;
  set version(int value) => saveInt(VERSION, value);

  // Theme
  String get theme => getString(THEME) ?? "";
  set theme(String value) => saveString(THEME, value);

  // Score
  int get score => getInt(SCORE) ?? 0;

  // Pending Friends
  bool get pendingFriends => getBool(PENDING_FRIENDS) ?? false;
  set pendingFriends(bool value) => saveBool(PENDING_FRIENDS, value);

  // Pending Competition
  bool get pendingCompetition => getBool(COMPETITION_FRIENDS) ?? false;
  set pendingCompetition(bool value) => saveBool(COMPETITION_FRIENDS, value);

  // Pending Learn
  int get pendingLearn => getInt(NEW_LEARN_TEXT) ?? 0;
  set pendingLearn(int value) => saveInt(NEW_LEARN_TEXT, value);

  // TUTORIAL
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
