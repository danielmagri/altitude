// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:altitude/common/app_logic.dart' as _i39;
import 'package:altitude/common/domain/usecases/habits/complete_habit_usecase.dart'
    as _i37;
import 'package:altitude/common/domain/usecases/habits/get_habits_usecase.dart'
    as _i36;
import 'package:altitude/common/domain/usecases/habits/max_habits_usecase.dart'
    as _i38;
import 'package:altitude/common/sharedPref/SharedPref.dart' as _i33;
import 'package:altitude/common/useCase/CompetitionUseCase.dart' as _i8;
import 'package:altitude/common/useCase/HabitUseCase.dart' as _i6;
import 'package:altitude/common/useCase/PersonUseCase.dart' as _i4;
import 'package:altitude/core/services/FireAnalytics.dart' as _i41;
import 'package:altitude/core/services/FireAuth.dart' as _i23;
import 'package:altitude/core/services/FireDatabase.dart' as _i24;
import 'package:altitude/core/services/FireFunctions.dart' as _i25;
import 'package:altitude/core/services/FireMenssaging.dart' as _i26;
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart'
    as _i14;
import 'package:altitude/core/services/interfaces/i_fire_auth.dart' as _i22;
import 'package:altitude/core/services/interfaces/i_fire_database.dart' as _i11;
import 'package:altitude/core/services/interfaces/i_fire_functions.dart'
    as _i13;
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart'
    as _i12;
import 'package:altitude/core/services/interfaces/i_local_notification.dart'
    as _i21;
import 'package:altitude/core/services/LocalNotification.dart' as _i42;
import 'package:altitude/core/services/Memory.dart' as _i10;
import 'package:altitude/feature/addHabit/logic/AddHabitLogic.dart' as _i5;
import 'package:altitude/feature/competition/logic/CompetitionDetailsLogic.dart'
    as _i7;
import 'package:altitude/feature/competition/logic/CompetitionLogic.dart'
    as _i9;
import 'package:altitude/feature/competition/logic/CreateCompetitionLogic.dart'
    as _i15;
import 'package:altitude/feature/competition/logic/PendingCompetitionLogic.dart'
    as _i30;
import 'package:altitude/feature/editHabit/logic/EditHabitLogic.dart' as _i19;
import 'package:altitude/feature/friends/logic/AddFriendLogic.dart' as _i3;
import 'package:altitude/feature/friends/logic/FriendsLogic.dart' as _i20;
import 'package:altitude/feature/friends/logic/PendingFriendsLogic.dart'
    as _i31;
import 'package:altitude/feature/habitDetails/logic/EditAlarmLogic.dart'
    as _i16;
import 'package:altitude/feature/habitDetails/logic/EditCueLogic.dart' as _i18;
import 'package:altitude/feature/habitDetails/logic/HabitDetailsLogic.dart'
    as _i17;
import 'package:altitude/feature/home/presentation/controllers/home_controller.dart'
    as _i35;
import 'package:altitude/feature/login/domain/usecases/auth_google_usecase.dart'
    as _i29;
import 'package:altitude/feature/login/presentation/controllers/login_controller.dart'
    as _i28;
import 'package:altitude/feature/setting/logic/SettingsLogic.dart' as _i32;
import 'package:altitude/feature/statistics/logic/StatisticsLogic.dart' as _i34;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'mocks/services_mocks.dart' as _i27;
import 'mocks/shared_pref_mock.dart' as _i43;
import 'mocks/use_case_mocks.dart' as _i40;

const String _usecase_test = 'usecase_test';
const String _usecase = 'usecase';
const String _service_test = 'service_test';
const String _service = 'service';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetItTest(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<_i3.AddFriendLogic>(
      () => _i3.AddFriendLogic(get<_i4.PersonUseCase>()));
  gh.lazySingleton<_i5.AddHabitLogic>(
      () => _i5.AddHabitLogic(get<_i6.HabitUseCase>()));
  gh.lazySingleton<_i7.CompetitionDetailsLogic>(() =>
      _i7.CompetitionDetailsLogic(
          get<_i4.PersonUseCase>(), get<_i8.CompetitionUseCase>()));
  gh.lazySingleton<_i9.CompetitionLogic>(() => _i9.CompetitionLogic(
      get<_i4.PersonUseCase>(),
      get<_i6.HabitUseCase>(),
      get<_i8.CompetitionUseCase>()));
  gh.factory<_i8.CompetitionUseCase>(
      () => _i8.CompetitionUseCase(
          get<_i10.Memory>(),
          get<_i4.PersonUseCase>(),
          get<_i11.IFireDatabase>(),
          get<_i12.IFireMessaging>(),
          get<_i13.IFireFunctions>(),
          get<_i14.IFireAnalytics>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i15.CreateCompetitionLogic>(
      () => _i15.CreateCompetitionLogic(get<_i8.CompetitionUseCase>()));
  gh.lazySingleton<_i16.EditAlarmLogic>(() => _i16.EditAlarmLogic(
      get<_i17.HabitDetailsLogic>(),
      get<_i6.HabitUseCase>(),
      get<_i14.IFireAnalytics>()));
  gh.lazySingleton<_i18.EditCueLogic>(() => _i18.EditCueLogic(
      get<_i6.HabitUseCase>(),
      get<_i14.IFireAnalytics>(),
      get<_i17.HabitDetailsLogic>()));
  gh.lazySingleton<_i19.EditHabitLogic>(
      () => _i19.EditHabitLogic(get<_i6.HabitUseCase>()));
  gh.lazySingleton<_i20.FriendsLogic>(
      () => _i20.FriendsLogic(get<_i4.PersonUseCase>()));
  gh.lazySingleton<_i17.HabitDetailsLogic>(() => _i17.HabitDetailsLogic(
      get<_i6.HabitUseCase>(), get<_i8.CompetitionUseCase>()));
  gh.factory<_i6.HabitUseCase>(
      () => _i6.HabitUseCase(
          get<_i10.Memory>(),
          get<_i4.PersonUseCase>(),
          get<_i8.CompetitionUseCase>(),
          get<_i11.IFireDatabase>(),
          get<_i21.ILocalNotification>(),
          get<_i14.IFireAnalytics>(),
          get<_i13.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i22.IFireAuth>(() => _i23.FireAuth(), registerFor: {_service});
  gh.factory<_i11.IFireDatabase>(() => _i24.FireDatabase(),
      registerFor: {_service});
  gh.factory<_i13.IFireFunctions>(() => _i25.FireFunctions(),
      registerFor: {_service});
  gh.factory<_i12.IFireMessaging>(() => _i26.FireMessaging(),
      registerFor: {_service});
  gh.lazySingleton<_i21.ILocalNotification>(() => _i27.MockLocalNotification(),
      registerFor: {_service_test});
  gh.lazySingleton<_i28.LoginController>(
      () => _i28.LoginController(get<_i29.AuthGoogleUsecase>()));
  gh.lazySingleton<_i30.PendingCompetitionLogic>(() =>
      _i30.PendingCompetitionLogic(
          get<_i8.CompetitionUseCase>(), get<_i6.HabitUseCase>()));
  gh.lazySingleton<_i31.PendingFriendsLogic>(
      () => _i31.PendingFriendsLogic(get<_i4.PersonUseCase>()));
  gh.factory<_i4.PersonUseCase>(
      () => _i4.PersonUseCase(
          get<_i10.Memory>(),
          get<_i22.IFireAuth>(),
          get<_i12.IFireMessaging>(),
          get<_i11.IFireDatabase>(),
          get<_i14.IFireAnalytics>(),
          get<_i13.IFireFunctions>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i32.SettingsLogic>(() => _i32.SettingsLogic(
      get<_i4.PersonUseCase>(),
      get<_i6.HabitUseCase>(),
      get<_i8.CompetitionUseCase>(),
      get<_i33.SharedPref>()));
  gh.lazySingleton<_i34.StatisticsLogic>(() =>
      _i34.StatisticsLogic(get<_i4.PersonUseCase>(), get<_i6.HabitUseCase>()));
  gh.lazySingleton<_i35.HomeController>(() => _i35.HomeController(
      get<_i36.GetHabitsUsecase>(),
      get<_i37.CompleteHabitUsecase>(),
      get<_i38.MaxHabitsUsecase>(),
      get<_i14.IFireAnalytics>(),
      get<_i39.AppLogic>(),
      get<_i4.PersonUseCase>(),
      get<_i8.CompetitionUseCase>()));
  gh.singleton<_i39.AppLogic>(_i39.AppLogic());
  gh.singleton<_i8.CompetitionUseCase>(_i40.MockCompetitionUseCase(),
      registerFor: {_usecase_test});
  gh.singleton<_i6.HabitUseCase>(_i40.MockHabitUseCase(),
      registerFor: {_usecase_test});
  gh.singleton<_i14.IFireAnalytics>(_i27.MockFireAnalytics(),
      registerFor: {_service_test});
  gh.singleton<_i14.IFireAnalytics>(_i41.FireAnalytics(),
      registerFor: {_service});
  gh.singleton<_i22.IFireAuth>(_i27.MockFireAuth(),
      registerFor: {_service_test});
  gh.singleton<_i11.IFireDatabase>(_i27.MockFireDatabase(),
      registerFor: {_service_test});
  gh.singleton<_i13.IFireFunctions>(_i27.MockFireFunctions(),
      registerFor: {_service_test});
  gh.singleton<_i12.IFireMessaging>(_i27.MockFireMessaging(),
      registerFor: {_service_test});
  gh.singletonAsync<_i21.ILocalNotification>(
      () => _i42.LocalNotification.initialize(),
      registerFor: {_service});
  gh.singleton<_i10.Memory>(_i10.Memory());
  gh.singleton<_i43.MockSharedPref>(_i43.MockSharedPref(),
      registerFor: {_service_test});
  gh.singleton<_i4.PersonUseCase>(_i40.MockPersonUseCase(),
      registerFor: {_usecase_test});
  gh.singletonAsync<_i33.SharedPref>(() => _i33.SharedPref.initialize(),
      registerFor: {_service});
  return get;
}
