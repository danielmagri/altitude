// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../common/app_logic.dart' as _i23;
import '../../common/sharedPref/SharedPref.dart' as _i33;
import '../../common/useCase/CompetitionUseCase.dart' as _i8;
import '../../common/useCase/HabitUseCase.dart' as _i6;
import '../../common/useCase/PersonUseCase.dart' as _i4;
import '../../feature/addHabit/logic/AddHabitLogic.dart' as _i5;
import '../../feature/competition/logic/CompetitionDetailsLogic.dart' as _i7;
import '../../feature/competition/logic/CompetitionLogic.dart' as _i9;
import '../../feature/competition/logic/CreateCompetitionLogic.dart' as _i15;
import '../../feature/competition/logic/PendingCompetitionLogic.dart' as _i30;
import '../../feature/editHabit/logic/EditHabitLogic.dart' as _i19;
import '../../feature/friends/logic/AddFriendLogic.dart' as _i3;
import '../../feature/friends/logic/FriendsLogic.dart' as _i20;
import '../../feature/friends/logic/PendingFriendsLogic.dart' as _i31;
import '../../feature/habitDetails/logic/EditAlarmLogic.dart' as _i16;
import '../../feature/habitDetails/logic/EditCueLogic.dart' as _i18;
import '../../feature/habitDetails/logic/HabitDetailsLogic.dart' as _i17;
import '../../feature/home/logic/HomeLogic.dart' as _i22;
import '../../feature/login/logic/LoginLogic.dart' as _i29;
import '../../feature/setting/logic/SettingsLogic.dart' as _i32;
import '../../feature/statistics/logic/StatisticsLogic.dart' as _i34;
import '../services/FireAnalytics.dart' as _i35;
import '../services/FireAuth.dart' as _i25;
import '../services/FireDatabase.dart' as _i26;
import '../services/FireFunctions.dart' as _i27;
import '../services/FireMenssaging.dart' as _i28;
import '../services/interfaces/i_fire_analytics.dart' as _i14;
import '../services/interfaces/i_fire_auth.dart' as _i24;
import '../services/interfaces/i_fire_database.dart' as _i11;
import '../services/interfaces/i_fire_functions.dart' as _i13;
import '../services/interfaces/i_fire_messaging.dart' as _i12;
import '../services/interfaces/i_local_notification.dart' as _i21;
import '../services/LocalNotification.dart' as _i36;
import '../services/Memory.dart' as _i10;

const String _usecase = 'usecase';
const String _service = 'service';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
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
  gh.lazySingleton<_i22.HomeLogic>(() => _i22.HomeLogic(
      get<_i6.HabitUseCase>(),
      get<_i4.PersonUseCase>(),
      get<_i8.CompetitionUseCase>(),
      get<_i14.IFireAnalytics>(),
      get<_i23.AppLogic>()));
  gh.factory<_i24.IFireAuth>(() => _i25.FireAuth(), registerFor: {_service});
  gh.factory<_i11.IFireDatabase>(() => _i26.FireDatabase(),
      registerFor: {_service});
  gh.factory<_i13.IFireFunctions>(() => _i27.FireFunctions(),
      registerFor: {_service});
  gh.factory<_i12.IFireMessaging>(() => _i28.FireMessaging(),
      registerFor: {_service});
  gh.lazySingleton<_i29.LoginLogic>(() => _i29.LoginLogic());
  gh.lazySingleton<_i30.PendingCompetitionLogic>(() =>
      _i30.PendingCompetitionLogic(
          get<_i8.CompetitionUseCase>(), get<_i6.HabitUseCase>()));
  gh.lazySingleton<_i31.PendingFriendsLogic>(
      () => _i31.PendingFriendsLogic(get<_i4.PersonUseCase>()));
  gh.factory<_i4.PersonUseCase>(
      () => _i4.PersonUseCase(
          get<_i10.Memory>(),
          get<_i24.IFireAuth>(),
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
  gh.singleton<_i23.AppLogic>(_i23.AppLogic());
  gh.singleton<_i14.IFireAnalytics>(_i35.FireAnalytics(),
      registerFor: {_service});
  gh.singletonAsync<_i21.ILocalNotification>(
      () => _i36.LocalNotification.initialize(),
      registerFor: {_service});
  gh.singleton<_i10.Memory>(_i10.Memory());
  gh.singletonAsync<_i33.SharedPref>(() => _i33.SharedPref.initialize(),
      registerFor: {_service});
  return get;
}
