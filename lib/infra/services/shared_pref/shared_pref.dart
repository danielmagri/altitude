import 'package:altitude/common/constant/shared_pref_keys.dart';
import 'package:altitude/infra/services/shared_pref/core/shared_pref_handler.dart';
import 'package:injectable/injectable.dart';

@preResolve
@singleton
class SharedPref extends SharedPrefHandler {
  @factoryMethod
  static Future<SharedPref> initialize() async {
    SharedPref instance = SharedPref();
    await instance.init();
    return instance;
  }

  // Version
  int get version => getInt(versionKey) ?? 0;
  set version(int value) => saveInt(versionKey, value);

  // Theme
  String get theme => getString(themeKey) ?? '';
  set theme(String value) => saveString(themeKey, value);

  // Score
  int get score => getInt(scoreKey) ?? 0;

  // Pending Friends
  bool get pendingFriends => getBool(pendingFriendsKey) ?? false;
  set pendingFriends(bool value) => saveBool(pendingFriendsKey, value);

  // Pending Competition
  bool get pendingCompetition => getBool(competitionFriendsKey) ?? false;
  set pendingCompetition(bool value) => saveBool(competitionFriendsKey, value);

  // Pending Learn
  int get pendingLearn => getInt(newLearnTextKey) ?? 0;
  set pendingLearn(int value) => saveInt(newLearnTextKey, value);

  // TUTORIAL
  // Habit Tutorial
  bool get habitTutorial => getBool(habitTutorialKey) ?? false;
  set habitTutorial(bool value) => saveBool(habitTutorialKey, value);

  // Competition Tutorial
  bool get competitionTutorial => getBool(competitionTutorialKey) ?? false;
  set competitionTutorial(bool value) =>
      saveBool(competitionTutorialKey, value);

  // Rocket Tutorial
  bool get rocketTutorial => getBool(rocketOnDetailsPageKey) ?? false;
  set rocketTutorial(bool value) => saveBool(rocketOnDetailsPageKey, value);

  // Alarm Tutorial
  int get alarmTutorial => getInt(alarmOnDetailsPageKey) ?? 0;
  void addAlarmTutorial() => saveInt(alarmOnDetailsPageKey, alarmTutorial + 1);
}
