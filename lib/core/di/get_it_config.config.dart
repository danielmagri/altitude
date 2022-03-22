// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../common/app_logic.dart' as _i40;
import '../../common/domain/usecases/habits/complete_habit_usecase.dart'
    as _i38;
import '../../common/domain/usecases/habits/get_habit_usecase.dart' as _i35;
import '../../common/domain/usecases/habits/get_habits_usecase.dart' as _i36;
import '../../common/domain/usecases/habits/max_habits_usecase.dart' as _i37;
import '../../common/domain/usecases/notifications/send_competition_notification_usecase.dart'
    as _i31;
import '../../common/sharedPref/SharedPref.dart' as _i33;
import '../../common/useCase/CompetitionUseCase.dart' as _i9;
import '../../common/useCase/HabitUseCase.dart' as _i6;
import '../../common/useCase/PersonUseCase.dart' as _i4;
import '../../feature/competitions/presentation/controllers/competition_controller.dart'
    as _i8;
import '../../feature/competitions/presentation/controllers/competition_details_controller.dart'
    as _i10;
import '../../feature/competitions/presentation/controllers/create_competition_controller.dart'
    as _i16;
import '../../feature/competitions/presentation/controllers/pending_competition_controller.dart'
    as _i29;
import '../../feature/friends/presentation/controllers/add_friend_controller.dart'
    as _i3;
import '../../feature/friends/presentation/controllers/friends_controller.dart'
    as _i21;
import '../../feature/friends/presentation/controllers/pending_friends_controller.dart'
    as _i30;
import '../../feature/habits/presentation/controllers/add_habit_controller.dart'
    as _i5;
import '../../feature/habits/presentation/controllers/edit_alarm_controller.dart'
    as _i17;
import '../../feature/habits/presentation/controllers/edit_cue_controller.dart'
    as _i19;
import '../../feature/habits/presentation/controllers/edit_habit_controller.dart'
    as _i20;
import '../../feature/habits/presentation/controllers/habit_details_controller.dart'
    as _i18;
import '../../feature/home/presentation/controllers/home_controller.dart'
    as _i39;
import '../../feature/login/domain/usecases/auth_google_usecase.dart' as _i7;
import '../../feature/login/presentation/controllers/login_controller.dart'
    as _i28;
import '../../feature/setting/presentation/controllers/settings_controller.dart'
    as _i32;
import '../../feature/statistics/presentation/controllers/statistics_controller.dart'
    as _i34;
import '../services/FireAnalytics.dart' as _i41;
import '../services/FireAuth.dart' as _i24;
import '../services/FireDatabase.dart' as _i25;
import '../services/FireFunctions.dart' as _i26;
import '../services/FireMenssaging.dart' as _i27;
import '../services/interfaces/i_fire_analytics.dart' as _i15;
import '../services/interfaces/i_fire_auth.dart' as _i23;
import '../services/interfaces/i_fire_database.dart' as _i12;
import '../services/interfaces/i_fire_functions.dart' as _i14;
import '../services/interfaces/i_fire_messaging.dart' as _i13;
import '../services/interfaces/i_local_notification.dart' as _i22;
import '../services/LocalNotification.dart' as _i42;
import '../services/Memory.dart' as _i11;

const String _usecase = 'usecase';
const String _service = 'service';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<_i3.AddFriendController>(
      () => _i3.AddFriendController(get<_i4.PersonUseCase>()));
  gh.lazySingleton<_i5.AddHabitController>(
      () => _i5.AddHabitController(get<_i6.HabitUseCase>()));
  gh.factory<_i7.AuthGoogleUsecase>(() => _i7.AuthGoogleUsecase(),
      registerFor: {_usecase});
  gh.lazySingleton<_i8.CompetitionController>(() => _i8.CompetitionController(
      get<_i4.PersonUseCase>(),
      get<_i6.HabitUseCase>(),
      get<_i9.CompetitionUseCase>()));
  gh.lazySingleton<_i10.CompetitionDetailsController>(() =>
      _i10.CompetitionDetailsController(
          get<_i4.PersonUseCase>(), get<_i9.CompetitionUseCase>()));
  gh.factory<_i9.CompetitionUseCase>(
      () => _i9.CompetitionUseCase(
          get<_i11.Memory>(),
          get<_i4.PersonUseCase>(),
          get<_i12.IFireDatabase>(),
          get<_i13.IFireMessaging>(),
          get<_i14.IFireFunctions>(),
          get<_i15.IFireAnalytics>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i16.CreateCompetitionController>(
      () => _i16.CreateCompetitionController(get<_i9.CompetitionUseCase>()));
  gh.lazySingleton<_i17.EditAlarmController>(() => _i17.EditAlarmController(
      get<_i18.HabitDetailsController>(),
      get<_i6.HabitUseCase>(),
      get<_i15.IFireAnalytics>()));
  gh.lazySingleton<_i19.EditCueController>(() => _i19.EditCueController(
      get<_i6.HabitUseCase>(),
      get<_i15.IFireAnalytics>(),
      get<_i18.HabitDetailsController>()));
  gh.lazySingleton<_i20.EditHabitController>(
      () => _i20.EditHabitController(get<_i6.HabitUseCase>()));
  gh.lazySingleton<_i21.FriendsController>(
      () => _i21.FriendsController(get<_i4.PersonUseCase>()));
  gh.lazySingleton<_i18.HabitDetailsController>(() =>
      _i18.HabitDetailsController(
          get<_i6.HabitUseCase>(), get<_i9.CompetitionUseCase>()));
  gh.factory<_i6.HabitUseCase>(
      () => _i6.HabitUseCase(
          get<_i11.Memory>(),
          get<_i4.PersonUseCase>(),
          get<_i9.CompetitionUseCase>(),
          get<_i12.IFireDatabase>(),
          get<_i22.ILocalNotification>(),
          get<_i15.IFireAnalytics>(),
          get<_i14.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i23.IFireAuth>(() => _i24.FireAuth(), registerFor: {_service});
  gh.factory<_i12.IFireDatabase>(() => _i25.FireDatabase(),
      registerFor: {_service});
  gh.factory<_i14.IFireFunctions>(() => _i26.FireFunctions(),
      registerFor: {_service});
  gh.factory<_i13.IFireMessaging>(() => _i27.FireMessaging(),
      registerFor: {_service});
  gh.lazySingleton<_i28.LoginController>(
      () => _i28.LoginController(get<_i7.AuthGoogleUsecase>()));
  gh.lazySingleton<_i29.PendingCompetitionController>(() =>
      _i29.PendingCompetitionController(
          get<_i9.CompetitionUseCase>(), get<_i6.HabitUseCase>()));
  gh.lazySingleton<_i30.PendingFriendsController>(
      () => _i30.PendingFriendsController(get<_i4.PersonUseCase>()));
  gh.factory<_i4.PersonUseCase>(
      () => _i4.PersonUseCase(
          get<_i11.Memory>(),
          get<_i23.IFireAuth>(),
          get<_i13.IFireMessaging>(),
          get<_i12.IFireDatabase>(),
          get<_i15.IFireAnalytics>(),
          get<_i14.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i31.SendCompetitionNotificationUsecase>(
      () => _i31.SendCompetitionNotificationUsecase(
          get<_i4.PersonUseCase>(), get<_i14.IFireFunctions>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i32.SettingsController>(() => _i32.SettingsController(
      get<_i4.PersonUseCase>(),
      get<_i6.HabitUseCase>(),
      get<_i9.CompetitionUseCase>(),
      get<_i33.SharedPref>()));
  gh.lazySingleton<_i34.StatisticsController>(() => _i34.StatisticsController(
      get<_i4.PersonUseCase>(), get<_i6.HabitUseCase>()));
  gh.factory<_i35.GetHabitUsecase>(
      () => _i35.GetHabitUsecase(get<_i11.Memory>(), get<_i12.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i36.GetHabitsUsecase>(
      () =>
          _i36.GetHabitsUsecase(get<_i11.Memory>(), get<_i12.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i37.MaxHabitsUsecase>(
      () => _i37.MaxHabitsUsecase(get<_i36.GetHabitsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i38.CompleteHabitUsecase>(
      () => _i38.CompleteHabitUsecase(
          get<_i11.Memory>(),
          get<_i12.IFireDatabase>(),
          get<_i4.PersonUseCase>(),
          get<_i9.CompetitionUseCase>(),
          get<_i31.SendCompetitionNotificationUsecase>(),
          get<_i35.GetHabitUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i39.HomeController>(() => _i39.HomeController(
      get<_i36.GetHabitsUsecase>(),
      get<_i38.CompleteHabitUsecase>(),
      get<_i37.MaxHabitsUsecase>(),
      get<_i15.IFireAnalytics>(),
      get<_i40.AppLogic>(),
      get<_i4.PersonUseCase>(),
      get<_i9.CompetitionUseCase>()));
  gh.singleton<_i40.AppLogic>(_i40.AppLogic());
  gh.singleton<_i15.IFireAnalytics>(_i41.FireAnalytics(),
      registerFor: {_service});
  gh.singletonAsync<_i22.ILocalNotification>(
      () => _i42.LocalNotification.initialize(),
      registerFor: {_service});
  gh.singleton<_i11.Memory>(_i11.Memory());
  gh.singletonAsync<_i33.SharedPref>(() => _i33.SharedPref.initialize(),
      registerFor: {_service});
  return get;
}
