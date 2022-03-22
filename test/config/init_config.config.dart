// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:altitude/common/app_logic.dart' as _i41;
import 'package:altitude/common/domain/usecases/habits/complete_habit_usecase.dart'
    as _i39;
import 'package:altitude/common/domain/usecases/habits/get_habit_usecase.dart'
    as _i36;
import 'package:altitude/common/domain/usecases/habits/get_habits_usecase.dart'
    as _i37;
import 'package:altitude/common/domain/usecases/habits/max_habits_usecase.dart'
    as _i38;
import 'package:altitude/common/domain/usecases/notifications/send_competition_notification_usecase.dart'
    as _i32;
import 'package:altitude/common/sharedPref/SharedPref.dart' as _i34;
import 'package:altitude/common/useCase/CompetitionUseCase.dart' as _i9;
import 'package:altitude/common/useCase/HabitUseCase.dart' as _i6;
import 'package:altitude/common/useCase/PersonUseCase.dart' as _i4;
import 'package:altitude/core/services/FireAnalytics.dart' as _i43;
import 'package:altitude/core/services/FireAuth.dart' as _i24;
import 'package:altitude/core/services/FireDatabase.dart' as _i25;
import 'package:altitude/core/services/FireFunctions.dart' as _i26;
import 'package:altitude/core/services/FireMenssaging.dart' as _i27;
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart'
    as _i15;
import 'package:altitude/core/services/interfaces/i_fire_auth.dart' as _i23;
import 'package:altitude/core/services/interfaces/i_fire_database.dart' as _i12;
import 'package:altitude/core/services/interfaces/i_fire_functions.dart'
    as _i14;
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart'
    as _i13;
import 'package:altitude/core/services/interfaces/i_local_notification.dart'
    as _i22;
import 'package:altitude/core/services/LocalNotification.dart' as _i44;
import 'package:altitude/core/services/Memory.dart' as _i11;
import 'package:altitude/feature/competitions/presentation/controllers/competition_controller.dart'
    as _i8;
import 'package:altitude/feature/competitions/presentation/controllers/competition_details_controller.dart'
    as _i10;
import 'package:altitude/feature/competitions/presentation/controllers/create_competition_controller.dart'
    as _i16;
import 'package:altitude/feature/competitions/presentation/controllers/pending_competition_controller.dart'
    as _i30;
import 'package:altitude/feature/friends/presentation/controllers/add_friend_controller.dart'
    as _i3;
import 'package:altitude/feature/friends/presentation/controllers/friends_controller.dart'
    as _i21;
import 'package:altitude/feature/friends/presentation/controllers/pending_friends_controller.dart'
    as _i31;
import 'package:altitude/feature/habits/presentation/controllers/add_habit_controller.dart'
    as _i5;
import 'package:altitude/feature/habits/presentation/controllers/edit_alarm_controller.dart'
    as _i17;
import 'package:altitude/feature/habits/presentation/controllers/edit_cue_controller.dart'
    as _i19;
import 'package:altitude/feature/habits/presentation/controllers/edit_habit_controller.dart'
    as _i20;
import 'package:altitude/feature/habits/presentation/controllers/habit_details_controller.dart'
    as _i18;
import 'package:altitude/feature/home/presentation/controllers/home_controller.dart'
    as _i40;
import 'package:altitude/feature/login/domain/usecases/auth_google_usecase.dart'
    as _i7;
import 'package:altitude/feature/login/presentation/controllers/login_controller.dart'
    as _i29;
import 'package:altitude/feature/setting/presentation/controllers/settings_controller.dart'
    as _i33;
import 'package:altitude/feature/statistics/presentation/controllers/statistics_controller.dart'
    as _i35;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'mocks/services_mocks.dart' as _i28;
import 'mocks/shared_pref_mock.dart' as _i45;
import 'mocks/use_case_mocks.dart' as _i42;

const String _usecase = 'usecase';
const String _usecase_test = 'usecase_test';
const String _service = 'service';
const String _service_test = 'service_test';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetItTest(_i1.GetIt get,
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
  gh.lazySingleton<_i22.ILocalNotification>(() => _i28.MockLocalNotification(),
      registerFor: {_service_test});
  gh.lazySingleton<_i29.LoginController>(
      () => _i29.LoginController(get<_i7.AuthGoogleUsecase>()));
  gh.lazySingleton<_i30.PendingCompetitionController>(() =>
      _i30.PendingCompetitionController(
          get<_i9.CompetitionUseCase>(), get<_i6.HabitUseCase>()));
  gh.lazySingleton<_i31.PendingFriendsController>(
      () => _i31.PendingFriendsController(get<_i4.PersonUseCase>()));
  gh.factory<_i4.PersonUseCase>(
      () => _i4.PersonUseCase(
          get<_i11.Memory>(),
          get<_i23.IFireAuth>(),
          get<_i13.IFireMessaging>(),
          get<_i12.IFireDatabase>(),
          get<_i15.IFireAnalytics>(),
          get<_i14.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i32.SendCompetitionNotificationUsecase>(
      () => _i32.SendCompetitionNotificationUsecase(
          get<_i4.PersonUseCase>(), get<_i14.IFireFunctions>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i33.SettingsController>(() => _i33.SettingsController(
      get<_i4.PersonUseCase>(),
      get<_i6.HabitUseCase>(),
      get<_i9.CompetitionUseCase>(),
      get<_i34.SharedPref>()));
  gh.lazySingleton<_i35.StatisticsController>(() => _i35.StatisticsController(
      get<_i4.PersonUseCase>(), get<_i6.HabitUseCase>()));
  gh.factory<_i36.GetHabitUsecase>(
      () => _i36.GetHabitUsecase(get<_i11.Memory>(), get<_i12.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i37.GetHabitsUsecase>(
      () =>
          _i37.GetHabitsUsecase(get<_i11.Memory>(), get<_i12.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i38.MaxHabitsUsecase>(
      () => _i38.MaxHabitsUsecase(get<_i37.GetHabitsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i39.CompleteHabitUsecase>(
      () => _i39.CompleteHabitUsecase(
          get<_i11.Memory>(),
          get<_i12.IFireDatabase>(),
          get<_i4.PersonUseCase>(),
          get<_i9.CompetitionUseCase>(),
          get<_i32.SendCompetitionNotificationUsecase>(),
          get<_i36.GetHabitUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i40.HomeController>(() => _i40.HomeController(
      get<_i37.GetHabitsUsecase>(),
      get<_i39.CompleteHabitUsecase>(),
      get<_i38.MaxHabitsUsecase>(),
      get<_i15.IFireAnalytics>(),
      get<_i41.AppLogic>(),
      get<_i4.PersonUseCase>(),
      get<_i9.CompetitionUseCase>()));
  gh.singleton<_i41.AppLogic>(_i41.AppLogic());
  gh.singleton<_i9.CompetitionUseCase>(_i42.MockCompetitionUseCase(),
      registerFor: {_usecase_test});
  gh.singleton<_i6.HabitUseCase>(_i42.MockHabitUseCase(),
      registerFor: {_usecase_test});
  gh.singleton<_i15.IFireAnalytics>(_i43.FireAnalytics(),
      registerFor: {_service});
  gh.singleton<_i15.IFireAnalytics>(_i28.MockFireAnalytics(),
      registerFor: {_service_test});
  gh.singleton<_i23.IFireAuth>(_i28.MockFireAuth(),
      registerFor: {_service_test});
  gh.singleton<_i12.IFireDatabase>(_i28.MockFireDatabase(),
      registerFor: {_service_test});
  gh.singleton<_i14.IFireFunctions>(_i28.MockFireFunctions(),
      registerFor: {_service_test});
  gh.singleton<_i13.IFireMessaging>(_i28.MockFireMessaging(),
      registerFor: {_service_test});
  gh.singletonAsync<_i22.ILocalNotification>(
      () => _i44.LocalNotification.initialize(),
      registerFor: {_service});
  gh.singleton<_i11.Memory>(_i11.Memory());
  gh.singleton<_i45.MockSharedPref>(_i45.MockSharedPref(),
      registerFor: {_service_test});
  gh.singleton<_i4.PersonUseCase>(_i42.MockPersonUseCase(),
      registerFor: {_usecase_test});
  gh.singletonAsync<_i34.SharedPref>(() => _i34.SharedPref.initialize(),
      registerFor: {_service});
  return get;
}
