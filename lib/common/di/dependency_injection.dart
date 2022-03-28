import 'package:altitude/common/app_logic.dart';
import 'package:altitude/common/domain/di.dart';
import 'package:altitude/common/infra/di.dart';
import 'package:altitude/common/shared_pref/shared_pref.dart';
import 'package:altitude/feature/competitions/di.dart';
import 'package:altitude/feature/friends/di.dart';
import 'package:altitude/feature/habits/di.dart';
import 'package:altitude/feature/home/di.dart';
import 'package:altitude/feature/login/di.dart';
import 'package:altitude/feature/setting/di.dart';
import 'package:altitude/feature/statistics/di.dart';
import 'package:get_it/get_it.dart';

GetIt serviceLocator = GetIt.instance;

void _setupCore() {
  serviceLocator.registerSingletonAsync(() => SharedPref.initialize());

  setupInfra();
  setupDomain();

  serviceLocator.registerSingleton(AppLogic());
}

void setupAll() {
  _setupCore();
  setupCompetitions();
  setupFriends();
  setupHabits();
  setupHome();
  setupLogin();
  setupSettings();
  setupStatistics();
}
