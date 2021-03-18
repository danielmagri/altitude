import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/feature/addHabit/logic/AddHabitLogic.dart';
import 'package:altitude/feature/competition/logic/CompetitionDetailsLogic.dart';
import 'package:altitude/feature/competition/logic/CompetitionLogic.dart';
import 'package:altitude/feature/competition/logic/CreateCompetitionLogic.dart';
import 'package:altitude/feature/competition/logic/PendingCompetitionLogic.dart';
import 'package:altitude/feature/editHabit/logic/EditHabitLogic.dart';
import 'package:altitude/feature/friends/logic/AddFriendLogic.dart';
import 'package:altitude/feature/friends/logic/FriendsLogic.dart';
import 'package:altitude/feature/friends/logic/PendingFriendsLogic.dart';
import 'package:altitude/feature/habitDetails/logic/EditAlarmLogic.dart';
import 'package:altitude/feature/habitDetails/logic/EditCueLogic.dart';
import 'package:altitude/feature/habitDetails/logic/HabitDetailsLogic.dart';
import 'package:altitude/feature/home/logic/HomeLogic.dart';
import 'package:altitude/feature/statistics/logic/StatisticsLogic.dart';
import 'package:altitude/feature/login/logic/LoginLogic.dart';
import 'package:altitude/feature/setting/logic/SettingsLogic.dart';
import 'package:get_it/get_it.dart';

class Getit {
  static init() {
    var getIt = GetIt.instance;

    getIt.registerSingletonAsync<SharedPref>(() => SharedPref.initialize());
    // getIt.registerSingletonAsync<FireConfig>(() => FireConfig.initialize());

    getIt.registerSingleton<Memory>(Memory());

    //USE CASE
    getIt.registerFactory<PersonUseCase>(() => PersonUseCase());
    getIt.registerFactory<CompetitionUseCase>(() => CompetitionUseCase());
    getIt.registerFactory<HabitUseCase>(() => HabitUseCase());
    // LOGIC
    getIt.registerLazySingleton<HomeLogic>(() => HomeLogic());
    getIt.registerLazySingleton<AddHabitLogic>(() => AddHabitLogic());
    getIt.registerLazySingleton<StatisticsLogic>(() => StatisticsLogic());
    getIt.registerLazySingleton<HabitDetailsLogic>(() => HabitDetailsLogic());
    getIt.registerLazySingleton<EditCueLogic>(() => EditCueLogic());
    getIt.registerLazySingleton<EditAlarmLogic>(() => EditAlarmLogic());
    getIt.registerLazySingleton<EditHabitLogic>(() => EditHabitLogic());
    getIt.registerLazySingleton<LoginLogic>(() => LoginLogic());
    getIt.registerLazySingleton<FriendsLogic>(() => FriendsLogic());
    getIt.registerLazySingleton<PendingFriendsLogic>(() => PendingFriendsLogic());
    getIt.registerLazySingleton<AddFriendLogic>(() => AddFriendLogic());
    getIt.registerLazySingleton<CompetitionLogic>(() => CompetitionLogic());
    getIt.registerLazySingleton<CreateCompetitionLogic>(() => CreateCompetitionLogic());
    getIt.registerLazySingleton<PendingCompetitionLogic>(() => PendingCompetitionLogic());
    getIt.registerLazySingleton<CompetitionDetailsLogic>(() => CompetitionDetailsLogic());
    getIt.registerLazySingleton<SettingsLogic>(() => SettingsLogic());
  }
}
