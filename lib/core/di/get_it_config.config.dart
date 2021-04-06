// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../common/app_logic.dart' as _i22;
import '../../common/sharedPref/SharedPref.dart' as _i26;
import '../../common/useCase/CompetitionUseCase.dart' as _i16;
import '../../common/useCase/HabitUseCase.dart' as _i19;
import '../../common/useCase/PersonUseCase.dart' as _i12;
import '../../feature/addHabit/logic/AddHabitLogic.dart' as _i28;
import '../../feature/competition/logic/CompetitionDetailsLogic.dart' as _i29;
import '../../feature/competition/logic/CompetitionLogic.dart' as _i30;
import '../../feature/competition/logic/CreateCompetitionLogic.dart' as _i17;
import '../../feature/competition/logic/PendingCompetitionLogic.dart' as _i23;
import '../../feature/editHabit/logic/EditHabitLogic.dart' as _i31;
import '../../feature/friends/logic/AddFriendLogic.dart' as _i15;
import '../../feature/friends/logic/FriendsLogic.dart' as _i18;
import '../../feature/friends/logic/PendingFriendsLogic.dart' as _i24;
import '../../feature/habitDetails/logic/EditAlarmLogic.dart' as _i33;
import '../../feature/habitDetails/logic/EditCueLogic.dart' as _i34;
import '../../feature/habitDetails/logic/HabitDetailsLogic.dart' as _i32;
import '../../feature/home/logic/HomeLogic.dart' as _i21;
import '../../feature/login/logic/LoginLogic.dart' as _i11;
import '../../feature/setting/logic/SettingsLogic.dart' as _i25;
import '../../feature/statistics/logic/StatisticsLogic.dart' as _i27;
import '../services/FireAnalytics.dart' as _i35;
import '../services/FireAuth.dart' as _i4;
import '../services/FireDatabase.dart' as _i6;
import '../services/FireFunctions.dart' as _i8;
import '../services/FireMenssaging.dart' as _i10;
import '../services/interfaces/i_fire_analytics.dart' as _i14;
import '../services/interfaces/i_fire_auth.dart' as _i3;
import '../services/interfaces/i_fire_database.dart' as _i5;
import '../services/interfaces/i_fire_functions.dart' as _i7;
import '../services/interfaces/i_fire_messaging.dart' as _i9;
import '../services/interfaces/i_local_notification.dart' as _i20;
import '../services/LocalNotification.dart' as _i36;
import '../services/Memory.dart' as _i13;

const String _service = 'service';
const String _usecase = 'usecase';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.IFireAuth>(() => _i4.FireAuth(), registerFor: {_service});
  gh.factory<_i5.IFireDatabase>(() => _i6.FireDatabase(),
      registerFor: {_service});
  gh.factory<_i7.IFireFunctions>(() => _i8.FireFunctions(),
      registerFor: {_service});
  gh.factory<_i9.IFireMessaging>(() => _i10.FireMessaging(),
      registerFor: {_service});
  gh.lazySingleton<_i11.LoginLogic>(() => _i11.LoginLogic());
  gh.factory<_i12.PersonUseCase>(
      () => _i12.PersonUseCase(
          get<_i13.Memory>(),
          get<_i3.IFireAuth>(),
          get<_i9.IFireMessaging>(),
          get<_i5.IFireDatabase>(),
          get<_i14.IFireAnalytics>(),
          get<_i7.IFireFunctions>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i15.AddFriendLogic>(
      () => _i15.AddFriendLogic(get<_i12.PersonUseCase>()));
  gh.factory<_i16.CompetitionUseCase>(
      () => _i16.CompetitionUseCase(
          get<_i13.Memory>(),
          get<_i12.PersonUseCase>(),
          get<_i5.IFireDatabase>(),
          get<_i9.IFireMessaging>(),
          get<_i7.IFireFunctions>(),
          get<_i14.IFireAnalytics>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i17.CreateCompetitionLogic>(
      () => _i17.CreateCompetitionLogic(get<_i16.CompetitionUseCase>()));
  gh.lazySingleton<_i18.FriendsLogic>(
      () => _i18.FriendsLogic(get<_i12.PersonUseCase>()));
  gh.factory<_i19.HabitUseCase>(
      () => _i19.HabitUseCase(
          get<_i13.Memory>(),
          get<_i12.PersonUseCase>(),
          get<_i16.CompetitionUseCase>(),
          get<_i5.IFireDatabase>(),
          get<_i20.ILocalNotification>(),
          get<_i14.IFireAnalytics>(),
          get<_i7.IFireFunctions>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i21.HomeLogic>(() => _i21.HomeLogic(
      get<_i19.HabitUseCase>(),
      get<_i12.PersonUseCase>(),
      get<_i16.CompetitionUseCase>(),
      get<_i14.IFireAnalytics>(),
      get<_i22.AppLogic>()));
  gh.lazySingleton<_i23.PendingCompetitionLogic>(() =>
      _i23.PendingCompetitionLogic(
          get<_i16.CompetitionUseCase>(), get<_i19.HabitUseCase>()));
  gh.lazySingleton<_i24.PendingFriendsLogic>(
      () => _i24.PendingFriendsLogic(get<_i12.PersonUseCase>()));
  gh.lazySingleton<_i25.SettingsLogic>(() => _i25.SettingsLogic(
      get<_i12.PersonUseCase>(),
      get<_i19.HabitUseCase>(),
      get<_i16.CompetitionUseCase>(),
      get<_i26.SharedPref>()));
  gh.lazySingleton<_i27.StatisticsLogic>(() => _i27.StatisticsLogic(
      get<_i12.PersonUseCase>(), get<_i19.HabitUseCase>()));
  gh.lazySingleton<_i28.AddHabitLogic>(
      () => _i28.AddHabitLogic(get<_i19.HabitUseCase>()));
  gh.lazySingleton<_i29.CompetitionDetailsLogic>(() =>
      _i29.CompetitionDetailsLogic(
          get<_i12.PersonUseCase>(), get<_i16.CompetitionUseCase>()));
  gh.lazySingleton<_i30.CompetitionLogic>(() => _i30.CompetitionLogic(
      get<_i12.PersonUseCase>(),
      get<_i19.HabitUseCase>(),
      get<_i16.CompetitionUseCase>()));
  gh.lazySingleton<_i31.EditHabitLogic>(
      () => _i31.EditHabitLogic(get<_i19.HabitUseCase>()));
  gh.lazySingleton<_i32.HabitDetailsLogic>(() => _i32.HabitDetailsLogic(
      get<_i19.HabitUseCase>(), get<_i16.CompetitionUseCase>()));
  gh.lazySingleton<_i33.EditAlarmLogic>(() => _i33.EditAlarmLogic(
      get<_i32.HabitDetailsLogic>(),
      get<_i19.HabitUseCase>(),
      get<_i14.IFireAnalytics>()));
  gh.lazySingleton<_i34.EditCueLogic>(() => _i34.EditCueLogic(
      get<_i19.HabitUseCase>(),
      get<_i14.IFireAnalytics>(),
      get<_i32.HabitDetailsLogic>()));
  gh.singleton<_i22.AppLogic>(_i22.AppLogic());
  gh.singleton<_i14.IFireAnalytics>(_i35.FireAnalytics(),
      registerFor: {_service});
  gh.singletonAsync<_i20.ILocalNotification>(
      () => _i36.LocalNotification.initialize(),
      registerFor: {_service});
  gh.singleton<_i13.Memory>(_i13.Memory());
  gh.singletonAsync<_i26.SharedPref>(() => _i26.SharedPref.initialize(),
      registerFor: {_service});
  return get;
}
