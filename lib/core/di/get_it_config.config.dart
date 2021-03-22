// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../common/sharedPref/SharedPref.dart' as _i34;
import '../../common/useCase/CompetitionUseCase.dart' as _i17;
import '../../common/useCase/HabitUseCase.dart' as _i20;
import '../../common/useCase/PersonUseCase.dart' as _i13;
import '../../feature/addHabit/logic/AddHabitLogic.dart' as _i26;
import '../../feature/competition/logic/CompetitionDetailsLogic.dart' as _i27;
import '../../feature/competition/logic/CompetitionLogic.dart' as _i28;
import '../../feature/competition/logic/CreateCompetitionLogic.dart' as _i18;
import '../../feature/competition/logic/PendingCompetitionLogic.dart' as _i22;
import '../../feature/editHabit/logic/EditHabitLogic.dart' as _i29;
import '../../feature/friends/logic/AddFriendLogic.dart' as _i16;
import '../../feature/friends/logic/FriendsLogic.dart' as _i19;
import '../../feature/friends/logic/PendingFriendsLogic.dart' as _i23;
import '../../feature/habitDetails/logic/EditAlarmLogic.dart' as _i31;
import '../../feature/habitDetails/logic/EditCueLogic.dart' as _i32;
import '../../feature/habitDetails/logic/HabitDetailsLogic.dart' as _i30;
import '../../feature/home/logic/HomeLogic.dart' as _i21;
import '../../feature/setting/logic/SettingsLogic.dart' as _i24;
import '../../feature/statistics/logic/StatisticsLogic.dart' as _i25;
import '../services/FireAnalytics.dart' as _i33;
import '../services/FireAuth.dart' as _i4;
import '../services/FireDatabase.dart' as _i6;
import '../services/FireFunctions.dart' as _i8;
import '../services/FireMenssaging.dart' as _i10;
import '../services/interfaces/i_fire_analytics.dart' as _i15;
import '../services/interfaces/i_fire_auth.dart' as _i3;
import '../services/interfaces/i_fire_database.dart' as _i5;
import '../services/interfaces/i_fire_functions.dart' as _i7;
import '../services/interfaces/i_fire_messaging.dart' as _i9;
import '../services/interfaces/i_local_notification.dart' as _i11;
import '../services/LocalNotification.dart' as _i12;
import '../services/Memory.dart' as _i14;

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
  gh.lazySingleton<_i11.ILocalNotification>(() => _i12.LocalNotification(),
      registerFor: {_service});
  gh.factory<_i13.PersonUseCase>(
      () => _i13.PersonUseCase(
          get<_i14.Memory>(),
          get<_i3.IFireAuth>(),
          get<_i9.IFireMessaging>(),
          get<_i5.IFireDatabase>(),
          get<_i15.IFireAnalytics>(),
          get<_i7.IFireFunctions>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i16.AddFriendLogic>(
      () => _i16.AddFriendLogic(get<_i13.PersonUseCase>()));
  gh.factory<_i17.CompetitionUseCase>(
      () => _i17.CompetitionUseCase(
          get<_i14.Memory>(),
          get<_i13.PersonUseCase>(),
          get<_i5.IFireDatabase>(),
          get<_i9.IFireMessaging>(),
          get<_i7.IFireFunctions>(),
          get<_i15.IFireAnalytics>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i18.CreateCompetitionLogic>(
      () => _i18.CreateCompetitionLogic(get<_i17.CompetitionUseCase>()));
  gh.lazySingleton<_i19.FriendsLogic>(
      () => _i19.FriendsLogic(get<_i13.PersonUseCase>()));
  gh.factory<_i20.HabitUseCase>(
      () => _i20.HabitUseCase(
          get<_i14.Memory>(),
          get<_i13.PersonUseCase>(),
          get<_i17.CompetitionUseCase>(),
          get<_i5.IFireDatabase>(),
          get<_i11.ILocalNotification>(),
          get<_i15.IFireAnalytics>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i21.HomeLogic>(() => _i21.HomeLogic(
      get<_i20.HabitUseCase>(),
      get<_i13.PersonUseCase>(),
      get<_i17.CompetitionUseCase>(),
      get<_i15.IFireAnalytics>()));
  gh.lazySingleton<_i22.PendingCompetitionLogic>(() =>
      _i22.PendingCompetitionLogic(
          get<_i17.CompetitionUseCase>(), get<_i20.HabitUseCase>()));
  gh.lazySingleton<_i23.PendingFriendsLogic>(
      () => _i23.PendingFriendsLogic(get<_i13.PersonUseCase>()));
  gh.lazySingleton<_i24.SettingsLogic>(() => _i24.SettingsLogic(
      get<_i13.PersonUseCase>(),
      get<_i20.HabitUseCase>(),
      get<_i17.CompetitionUseCase>()));
  gh.lazySingleton<_i25.StatisticsLogic>(() => _i25.StatisticsLogic(
      get<_i13.PersonUseCase>(), get<_i20.HabitUseCase>()));
  gh.lazySingleton<_i26.AddHabitLogic>(
      () => _i26.AddHabitLogic(get<_i20.HabitUseCase>()));
  gh.lazySingleton<_i27.CompetitionDetailsLogic>(() =>
      _i27.CompetitionDetailsLogic(
          get<_i13.PersonUseCase>(), get<_i17.CompetitionUseCase>()));
  gh.lazySingleton<_i28.CompetitionLogic>(() => _i28.CompetitionLogic(
      get<_i13.PersonUseCase>(),
      get<_i20.HabitUseCase>(),
      get<_i17.CompetitionUseCase>()));
  gh.lazySingleton<_i29.EditHabitLogic>(
      () => _i29.EditHabitLogic(get<_i20.HabitUseCase>()));
  gh.lazySingleton<_i30.HabitDetailsLogic>(() => _i30.HabitDetailsLogic(
      get<_i20.HabitUseCase>(),
      get<_i17.CompetitionUseCase>(),
      get<_i15.IFireAnalytics>()));
  gh.lazySingleton<_i31.EditAlarmLogic>(() => _i31.EditAlarmLogic(
      get<_i30.HabitDetailsLogic>(),
      get<_i20.HabitUseCase>(),
      get<_i15.IFireAnalytics>()));
  gh.lazySingleton<_i32.EditCueLogic>(() => _i32.EditCueLogic(
      get<_i20.HabitUseCase>(), get<_i30.HabitDetailsLogic>()));
  gh.singleton<_i15.IFireAnalytics>(_i33.FireAnalytics(),
      registerFor: {_service});
  gh.singleton<_i14.Memory>(_i14.Memory());
  gh.singletonAsync<_i34.SharedPref>(() => _i34.SharedPref.initialize(),
      registerFor: {_service});
  return get;
}
