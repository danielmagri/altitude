// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:altitude/common/app_logic.dart' as _i31;
import 'package:altitude/common/sharedPref/SharedPref.dart' as _i39;
import 'package:altitude/common/useCase/CompetitionUseCase.dart' as _i4;
import 'package:altitude/common/useCase/HabitUseCase.dart' as _i17;
import 'package:altitude/common/useCase/PersonUseCase.dart' as _i18;
import 'package:altitude/core/services/FireAnalytics.dart' as _i36;
import 'package:altitude/core/services/FireAuth.dart' as _i6;
import 'package:altitude/core/services/FireDatabase.dart' as _i8;
import 'package:altitude/core/services/FireFunctions.dart' as _i10;
import 'package:altitude/core/services/FireMenssaging.dart' as _i12;
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart'
    as _i20;
import 'package:altitude/core/services/interfaces/i_fire_auth.dart' as _i5;
import 'package:altitude/core/services/interfaces/i_fire_database.dart' as _i7;
import 'package:altitude/core/services/interfaces/i_fire_functions.dart' as _i9;
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart'
    as _i11;
import 'package:altitude/core/services/interfaces/i_local_notification.dart'
    as _i13;
import 'package:altitude/core/services/LocalNotification.dart' as _i37;
import 'package:altitude/core/services/Memory.dart' as _i19;
import 'package:altitude/feature/addHabit/logic/AddHabitLogic.dart' as _i24;
import 'package:altitude/feature/competition/logic/CompetitionDetailsLogic.dart'
    as _i25;
import 'package:altitude/feature/competition/logic/CompetitionLogic.dart'
    as _i26;
import 'package:altitude/feature/competition/logic/CreateCompetitionLogic.dart'
    as _i3;
import 'package:altitude/feature/competition/logic/PendingCompetitionLogic.dart'
    as _i16;
import 'package:altitude/feature/editHabit/logic/EditHabitLogic.dart' as _i27;
import 'package:altitude/feature/friends/logic/AddFriendLogic.dart' as _i23;
import 'package:altitude/feature/friends/logic/FriendsLogic.dart' as _i28;
import 'package:altitude/feature/friends/logic/PendingFriendsLogic.dart'
    as _i32;
import 'package:altitude/feature/habitDetails/logic/EditAlarmLogic.dart'
    as _i33;
import 'package:altitude/feature/habitDetails/logic/EditCueLogic.dart' as _i34;
import 'package:altitude/feature/habitDetails/logic/HabitDetailsLogic.dart'
    as _i29;
import 'package:altitude/feature/home/logic/HomeLogic.dart' as _i30;
import 'package:altitude/feature/login/logic/LoginLogic.dart' as _i15;
import 'package:altitude/feature/setting/logic/SettingsLogic.dart' as _i21;
import 'package:altitude/feature/statistics/logic/StatisticsLogic.dart' as _i22;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'mocks/services_mocks.dart' as _i14;
import 'mocks/shared_pref_mock.dart' as _i38;
import 'mocks/use_case_mocks.dart' as _i35;

const String _usecase_test = 'usecase_test';
const String _service_test = 'service_test';
const String _service = 'service';
const String _usecase = 'usecase';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetItTest(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<_i3.CreateCompetitionLogic>(
      () => _i3.CreateCompetitionLogic(get<_i4.CompetitionUseCase>()));
  gh.factory<_i5.IFireAuth>(() => _i6.FireAuth(), registerFor: {_service});
  gh.factory<_i7.IFireDatabase>(() => _i8.FireDatabase(),
      registerFor: {_service});
  gh.factory<_i9.IFireFunctions>(() => _i10.FireFunctions(),
      registerFor: {_service});
  gh.factory<_i11.IFireMessaging>(() => _i12.FireMessaging(),
      registerFor: {_service});
  gh.lazySingleton<_i13.ILocalNotification>(() => _i14.MockLocalNotification(),
      registerFor: {_service_test});
  gh.lazySingleton<_i15.LoginLogic>(() => _i15.LoginLogic());
  gh.lazySingleton<_i16.PendingCompetitionLogic>(() =>
      _i16.PendingCompetitionLogic(
          get<_i4.CompetitionUseCase>(), get<_i17.HabitUseCase>()));
  gh.factory<_i18.PersonUseCase>(
      () => _i18.PersonUseCase(
          get<_i19.Memory>(),
          get<_i5.IFireAuth>(),
          get<_i11.IFireMessaging>(),
          get<_i7.IFireDatabase>(),
          get<_i20.IFireAnalytics>(),
          get<_i9.IFireFunctions>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i21.SettingsLogic>(() => _i21.SettingsLogic(
      get<_i18.PersonUseCase>(),
      get<_i17.HabitUseCase>(),
      get<_i4.CompetitionUseCase>()));
  gh.lazySingleton<_i22.StatisticsLogic>(() => _i22.StatisticsLogic(
      get<_i18.PersonUseCase>(), get<_i17.HabitUseCase>()));
  gh.lazySingleton<_i23.AddFriendLogic>(
      () => _i23.AddFriendLogic(get<_i18.PersonUseCase>()));
  gh.lazySingleton<_i24.AddHabitLogic>(
      () => _i24.AddHabitLogic(get<_i17.HabitUseCase>()));
  gh.lazySingleton<_i25.CompetitionDetailsLogic>(() =>
      _i25.CompetitionDetailsLogic(
          get<_i18.PersonUseCase>(), get<_i4.CompetitionUseCase>()));
  gh.lazySingleton<_i26.CompetitionLogic>(() => _i26.CompetitionLogic(
      get<_i18.PersonUseCase>(),
      get<_i17.HabitUseCase>(),
      get<_i4.CompetitionUseCase>()));
  gh.factory<_i4.CompetitionUseCase>(
      () => _i4.CompetitionUseCase(
          get<_i19.Memory>(),
          get<_i18.PersonUseCase>(),
          get<_i7.IFireDatabase>(),
          get<_i11.IFireMessaging>(),
          get<_i9.IFireFunctions>(),
          get<_i20.IFireAnalytics>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i27.EditHabitLogic>(
      () => _i27.EditHabitLogic(get<_i17.HabitUseCase>()));
  gh.lazySingleton<_i28.FriendsLogic>(
      () => _i28.FriendsLogic(get<_i18.PersonUseCase>()));
  gh.lazySingleton<_i29.HabitDetailsLogic>(() => _i29.HabitDetailsLogic(
      get<_i17.HabitUseCase>(), get<_i4.CompetitionUseCase>()));
  gh.factory<_i17.HabitUseCase>(
      () => _i17.HabitUseCase(
          get<_i19.Memory>(),
          get<_i18.PersonUseCase>(),
          get<_i4.CompetitionUseCase>(),
          get<_i7.IFireDatabase>(),
          get<_i13.ILocalNotification>(),
          get<_i20.IFireAnalytics>(),
          get<_i9.IFireFunctions>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i30.HomeLogic>(() => _i30.HomeLogic(
      get<_i17.HabitUseCase>(),
      get<_i18.PersonUseCase>(),
      get<_i4.CompetitionUseCase>(),
      get<_i20.IFireAnalytics>(),
      get<_i31.AppLogic>()));
  gh.lazySingleton<_i32.PendingFriendsLogic>(
      () => _i32.PendingFriendsLogic(get<_i18.PersonUseCase>()));
  gh.lazySingleton<_i33.EditAlarmLogic>(() => _i33.EditAlarmLogic(
      get<_i29.HabitDetailsLogic>(),
      get<_i17.HabitUseCase>(),
      get<_i20.IFireAnalytics>()));
  gh.lazySingleton<_i34.EditCueLogic>(() => _i34.EditCueLogic(
      get<_i17.HabitUseCase>(),
      get<_i20.IFireAnalytics>(),
      get<_i29.HabitDetailsLogic>()));
  gh.singleton<_i31.AppLogic>(_i31.AppLogic());
  gh.singleton<_i4.CompetitionUseCase>(_i35.MockCompetitionUseCase(),
      registerFor: {_usecase_test});
  gh.singleton<_i17.HabitUseCase>(_i35.MockHabitUseCase(),
      registerFor: {_usecase_test});
  gh.singleton<_i20.IFireAnalytics>(_i14.MockFireAnalytics(),
      registerFor: {_service_test});
  gh.singleton<_i20.IFireAnalytics>(_i36.FireAnalytics(),
      registerFor: {_service});
  gh.singleton<_i5.IFireAuth>(_i14.MockFireAuth(),
      registerFor: {_service_test});
  gh.singleton<_i7.IFireDatabase>(_i14.MockFireDatabase(),
      registerFor: {_service_test});
  gh.singleton<_i9.IFireFunctions>(_i14.MockFireFunctions(),
      registerFor: {_service_test});
  gh.singleton<_i11.IFireMessaging>(_i14.MockFireMessaging(),
      registerFor: {_service_test});
  gh.singletonAsync<_i13.ILocalNotification>(
      () => _i37.LocalNotification.initialize(),
      registerFor: {_service});
  gh.singleton<_i19.Memory>(_i19.Memory());
  gh.singleton<_i38.MockSharedPref>(_i38.MockSharedPref(),
      registerFor: {_service_test});
  gh.singleton<_i18.PersonUseCase>(_i35.MockPersonUseCase(),
      registerFor: {_usecase_test});
  gh.singletonAsync<_i39.SharedPref>(() => _i39.SharedPref.initialize(),
      registerFor: {_service});
  return get;
}
