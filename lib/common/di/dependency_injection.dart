import 'package:altitude/common/app_logic.dart';
import 'package:altitude/data/di.dart';
import 'package:altitude/domain/di.dart';
import 'package:altitude/infra/di.dart';
import 'package:altitude/common/shared_pref/shared_pref.dart';
import 'package:altitude/presentation/competitions/di.dart';
import 'package:altitude/presentation/friends/di.dart';
import 'package:altitude/presentation/habits/di.dart';
import 'package:altitude/presentation/home/di.dart';
import 'package:altitude/presentation/login/di.dart';
import 'package:altitude/presentation/setting/di.dart';
import 'package:altitude/presentation/statistics/di.dart';
import 'package:get_it/get_it.dart';

GetIt serviceLocator = GetIt.instance;

void _setupCore() {
  serviceLocator.registerSingletonAsync(() => SharedPref.initialize());

  setupInfra();
  setupData();
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
