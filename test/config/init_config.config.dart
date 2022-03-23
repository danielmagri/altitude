// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:altitude/common/app_logic.dart' as _i50;
import 'package:altitude/common/domain/usecases/competitions/get_competition_usecase.dart'
    as _i27;
import 'package:altitude/common/domain/usecases/competitions/get_competitions_usecase.dart'
    as _i28;
import 'package:altitude/common/domain/usecases/friends/get_friends_usecase.dart'
    as _i29;
import 'package:altitude/common/domain/usecases/habits/complete_habit_usecase.dart'
    as _i45;
import 'package:altitude/common/domain/usecases/habits/get_habit_usecase.dart'
    as _i30;
import 'package:altitude/common/domain/usecases/habits/get_habits_usecase.dart'
    as _i31;
import 'package:altitude/common/domain/usecases/habits/max_habits_usecase.dart'
    as _i37;
import 'package:altitude/common/domain/usecases/notifications/send_competition_notification_usecase.dart'
    as _i17;
import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart'
    as _i47;
import 'package:altitude/common/domain/usecases/user/update_fcm_token_usecase.dart'
    as _i42;
import 'package:altitude/common/shared_pref/shared_pref.dart' as _i33;
import 'package:altitude/common/useCase/CompetitionUseCase.dart' as _i44;
import 'package:altitude/common/useCase/HabitUseCase.dart' as _i22;
import 'package:altitude/common/useCase/PersonUseCase.dart' as _i18;
import 'package:altitude/core/services/FireAnalytics.dart' as _i56;
import 'package:altitude/core/services/FireAuth.dart' as _i5;
import 'package:altitude/core/services/FireDatabase.dart' as _i7;
import 'package:altitude/core/services/FireFunctions.dart' as _i9;
import 'package:altitude/core/services/FireMenssaging.dart' as _i11;
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart'
    as _i24;
import 'package:altitude/core/services/interfaces/i_fire_auth.dart' as _i4;
import 'package:altitude/core/services/interfaces/i_fire_database.dart' as _i6;
import 'package:altitude/core/services/interfaces/i_fire_functions.dart' as _i8;
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart'
    as _i10;
import 'package:altitude/core/services/interfaces/i_local_notification.dart'
    as _i12;
import 'package:altitude/core/services/LocalNotification.dart' as _i57;
import 'package:altitude/core/services/Memory.dart' as _i16;
import 'package:altitude/feature/competitions/domain/usecases/create_competition_usecase.dart'
    as _i23;
import 'package:altitude/feature/competitions/domain/usecases/decline_competition_request_usecase.dart'
    as _i25;
import 'package:altitude/feature/competitions/domain/usecases/get_pending_competitions_usecase.dart'
    as _i32;
import 'package:altitude/feature/competitions/domain/usecases/get_ranking_friends_usecase.dart'
    as _i34;
import 'package:altitude/feature/competitions/domain/usecases/max_competitions_by_habit_usecase.dart'
    as _i35;
import 'package:altitude/feature/competitions/domain/usecases/max_competitions_usecase.dart'
    as _i36;
import 'package:altitude/feature/competitions/domain/usecases/remove_competitor_usecase.dart'
    as _i15;
import 'package:altitude/feature/competitions/domain/usecases/update_competition_usecase.dart'
    as _i19;
import 'package:altitude/feature/competitions/presentation/controllers/competition_controller.dart'
    as _i51;
import 'package:altitude/feature/competitions/presentation/controllers/competition_details_controller.dart'
    as _i43;
import 'package:altitude/feature/competitions/presentation/controllers/create_competition_controller.dart'
    as _i46;
import 'package:altitude/feature/competitions/presentation/controllers/pending_competition_controller.dart'
    as _i38;
import 'package:altitude/feature/friends/presentation/controllers/add_friend_controller.dart'
    as _i20;
import 'package:altitude/feature/friends/presentation/controllers/friends_controller.dart'
    as _i54;
import 'package:altitude/feature/friends/presentation/controllers/pending_friends_controller.dart'
    as _i39;
import 'package:altitude/feature/habits/presentation/controllers/add_habit_controller.dart'
    as _i21;
import 'package:altitude/feature/habits/presentation/controllers/edit_alarm_controller.dart'
    as _i52;
import 'package:altitude/feature/habits/presentation/controllers/edit_cue_controller.dart'
    as _i53;
import 'package:altitude/feature/habits/presentation/controllers/edit_habit_controller.dart'
    as _i26;
import 'package:altitude/feature/habits/presentation/controllers/habit_details_controller.dart'
    as _i48;
import 'package:altitude/feature/home/presentation/controllers/home_controller.dart'
    as _i49;
import 'package:altitude/feature/login/domain/usecases/auth_google_usecase.dart'
    as _i3;
import 'package:altitude/feature/login/presentation/controllers/login_controller.dart'
    as _i14;
import 'package:altitude/feature/setting/presentation/controllers/settings_controller.dart'
    as _i40;
import 'package:altitude/feature/statistics/presentation/controllers/statistics_controller.dart'
    as _i41;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'mocks/services_mocks.dart' as _i13;
import 'mocks/shared_pref_mock.dart' as _i58;
import 'mocks/use_case_mocks.dart' as _i55;

const String _usecase = 'usecase';
const String _usecase_test = 'usecase_test';
const String _service_test = 'service_test';
const String _service = 'service';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetItTest(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.AuthGoogleUsecase>(() => _i3.AuthGoogleUsecase(),
      registerFor: {_usecase});
  gh.factory<_i4.IFireAuth>(() => _i5.FireAuth(), registerFor: {_service});
  gh.factory<_i6.IFireDatabase>(() => _i7.FireDatabase(),
      registerFor: {_service});
  gh.factory<_i8.IFireFunctions>(() => _i9.FireFunctions(),
      registerFor: {_service});
  gh.factory<_i10.IFireMessaging>(() => _i11.FireMessaging(),
      registerFor: {_service});
  gh.lazySingleton<_i12.ILocalNotification>(() => _i13.MockLocalNotification(),
      registerFor: {_service_test});
  gh.lazySingleton<_i14.LoginController>(
      () => _i14.LoginController(get<_i3.AuthGoogleUsecase>()));
  gh.factory<_i15.RemoveCompetitorUsecase>(
      () => _i15.RemoveCompetitorUsecase(
          get<_i6.IFireDatabase>(), get<_i16.Memory>(), get<_i4.IFireAuth>()),
      registerFor: {_usecase});
  gh.factory<_i17.SendCompetitionNotificationUsecase>(
      () => _i17.SendCompetitionNotificationUsecase(
          get<_i18.PersonUseCase>(), get<_i8.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i19.UpdateCompetitionUsecase>(
      () => _i19.UpdateCompetitionUsecase(
          get<_i6.IFireDatabase>(), get<_i16.Memory>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i20.AddFriendController>(
      () => _i20.AddFriendController(get<_i18.PersonUseCase>()));
  gh.lazySingleton<_i21.AddHabitController>(
      () => _i21.AddHabitController(get<_i22.HabitUseCase>()));
  gh.factory<_i23.CreateCompetitionUsecase>(
      () => _i23.CreateCompetitionUsecase(
          get<_i6.IFireDatabase>(),
          get<_i10.IFireMessaging>(),
          get<_i8.IFireFunctions>(),
          get<_i24.IFireAnalytics>(),
          get<_i4.IFireAuth>(),
          get<_i16.Memory>()),
      registerFor: {_usecase});
  gh.factory<_i25.DeclineCompetitionRequestUsecase>(
      () => _i25.DeclineCompetitionRequestUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i26.EditHabitController>(
      () => _i26.EditHabitController(get<_i22.HabitUseCase>()));
  gh.factory<_i27.GetCompetitionUsecase>(
      () => _i27.GetCompetitionUsecase(
          get<_i16.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i28.GetCompetitionsUsecase>(
      () => _i28.GetCompetitionsUsecase(
          get<_i16.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i29.GetFriendsUsecase>(
      () => _i29.GetFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i30.GetHabitUsecase>(
      () => _i30.GetHabitUsecase(get<_i16.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i31.GetHabitsUsecase>(
      () => _i31.GetHabitsUsecase(get<_i16.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i32.GetPendingCompetitionsUsecase>(
      () => _i32.GetPendingCompetitionsUsecase(
          get<_i6.IFireDatabase>(), get<_i33.SharedPref>()),
      registerFor: {_usecase});
  gh.factory<_i34.GetRankingFriendsUsecase>(
      () => _i34.GetRankingFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i35.MaxCompetitionsByHabitUsecase>(
      () => _i35.MaxCompetitionsByHabitUsecase(
          get<_i28.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i36.MaxCompetitionsUsecase>(
      () => _i36.MaxCompetitionsUsecase(get<_i28.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i37.MaxHabitsUsecase>(
      () => _i37.MaxHabitsUsecase(get<_i31.GetHabitsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i38.PendingCompetitionController>(() =>
      _i38.PendingCompetitionController(
          get<_i36.MaxCompetitionsUsecase>(),
          get<_i31.GetHabitsUsecase>(),
          get<_i33.SharedPref>(),
          get<_i32.GetPendingCompetitionsUsecase>(),
          get<_i25.DeclineCompetitionRequestUsecase>()));
  gh.lazySingleton<_i39.PendingFriendsController>(
      () => _i39.PendingFriendsController(get<_i18.PersonUseCase>()));
  gh.lazySingleton<_i40.SettingsController>(() => _i40.SettingsController(
      get<_i18.PersonUseCase>(),
      get<_i22.HabitUseCase>(),
      get<_i33.SharedPref>(),
      get<_i28.GetCompetitionsUsecase>()));
  gh.lazySingleton<_i41.StatisticsController>(() => _i41.StatisticsController(
      get<_i18.PersonUseCase>(),
      get<_i22.HabitUseCase>(),
      get<_i31.GetHabitsUsecase>()));
  gh.factory<_i42.UpdateFCMTokenUsecase>(
      () => _i42.UpdateFCMTokenUsecase(
          get<_i10.IFireMessaging>(),
          get<_i6.IFireDatabase>(),
          get<_i16.Memory>(),
          get<_i28.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i43.CompetitionDetailsController>(() =>
      _i43.CompetitionDetailsController(
          get<_i29.GetFriendsUsecase>(),
          get<_i15.RemoveCompetitorUsecase>(),
          get<_i19.UpdateCompetitionUsecase>()));
  gh.factory<_i44.CompetitionUseCase>(
      () => _i44.CompetitionUseCase(
          get<_i16.Memory>(),
          get<_i18.PersonUseCase>(),
          get<_i6.IFireDatabase>(),
          get<_i8.IFireFunctions>(),
          get<_i28.GetCompetitionsUsecase>(),
          get<_i27.GetCompetitionUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i45.CompleteHabitUsecase>(
      () => _i45.CompleteHabitUsecase(
          get<_i16.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i18.PersonUseCase>(),
          get<_i17.SendCompetitionNotificationUsecase>(),
          get<_i30.GetHabitUsecase>(),
          get<_i28.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i46.CreateCompetitionController>(() =>
      _i46.CreateCompetitionController(get<_i23.CreateCompetitionUsecase>(),
          get<_i35.MaxCompetitionsByHabitUsecase>()));
  gh.factory<_i47.GetUserDataUsecase>(
      () => _i47.GetUserDataUsecase(
          get<_i16.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i4.IFireAuth>(),
          get<_i10.IFireMessaging>(),
          get<_i42.UpdateFCMTokenUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i48.HabitDetailsController>(() =>
      _i48.HabitDetailsController(
          get<_i22.HabitUseCase>(),
          get<_i44.CompetitionUseCase>(),
          get<_i45.CompleteHabitUsecase>(),
          get<_i30.GetHabitUsecase>()));
  gh.factory<_i22.HabitUseCase>(
      () => _i22.HabitUseCase(
          get<_i16.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i12.ILocalNotification>(),
          get<_i24.IFireAnalytics>(),
          get<_i47.GetUserDataUsecase>(),
          get<_i28.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i49.HomeController>(() => _i49.HomeController(
      get<_i31.GetHabitsUsecase>(),
      get<_i45.CompleteHabitUsecase>(),
      get<_i37.MaxHabitsUsecase>(),
      get<_i24.IFireAnalytics>(),
      get<_i50.AppLogic>(),
      get<_i18.PersonUseCase>(),
      get<_i44.CompetitionUseCase>(),
      get<_i47.GetUserDataUsecase>()));
  gh.factory<_i18.PersonUseCase>(
      () => _i18.PersonUseCase(
          get<_i16.Memory>(),
          get<_i4.IFireAuth>(),
          get<_i10.IFireMessaging>(),
          get<_i6.IFireDatabase>(),
          get<_i24.IFireAnalytics>(),
          get<_i8.IFireFunctions>(),
          get<_i47.GetUserDataUsecase>(),
          get<_i42.UpdateFCMTokenUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i51.CompetitionController>(() => _i51.CompetitionController(
      get<_i31.GetHabitsUsecase>(),
      get<_i34.GetRankingFriendsUsecase>(),
      get<_i47.GetUserDataUsecase>(),
      get<_i28.GetCompetitionsUsecase>(),
      get<_i27.GetCompetitionUsecase>(),
      get<_i36.MaxCompetitionsUsecase>(),
      get<_i33.SharedPref>(),
      get<_i15.RemoveCompetitorUsecase>(),
      get<_i29.GetFriendsUsecase>()));
  gh.lazySingleton<_i52.EditAlarmController>(() => _i52.EditAlarmController(
      get<_i48.HabitDetailsController>(),
      get<_i22.HabitUseCase>(),
      get<_i24.IFireAnalytics>()));
  gh.lazySingleton<_i53.EditCueController>(() => _i53.EditCueController(
      get<_i22.HabitUseCase>(),
      get<_i24.IFireAnalytics>(),
      get<_i48.HabitDetailsController>()));
  gh.lazySingleton<_i54.FriendsController>(() => _i54.FriendsController(
      get<_i18.PersonUseCase>(),
      get<_i29.GetFriendsUsecase>(),
      get<_i47.GetUserDataUsecase>()));
  gh.singleton<_i50.AppLogic>(_i50.AppLogic());
  gh.singleton<_i44.CompetitionUseCase>(_i55.MockCompetitionUseCase(),
      registerFor: {_usecase_test});
  gh.singleton<_i22.HabitUseCase>(_i55.MockHabitUseCase(),
      registerFor: {_usecase_test});
  gh.singleton<_i24.IFireAnalytics>(_i13.MockFireAnalytics(),
      registerFor: {_service_test});
  gh.singleton<_i24.IFireAnalytics>(_i56.FireAnalytics(),
      registerFor: {_service});
  gh.singleton<_i4.IFireAuth>(_i13.MockFireAuth(),
      registerFor: {_service_test});
  gh.singleton<_i6.IFireDatabase>(_i13.MockFireDatabase(),
      registerFor: {_service_test});
  gh.singleton<_i8.IFireFunctions>(_i13.MockFireFunctions(),
      registerFor: {_service_test});
  gh.singleton<_i10.IFireMessaging>(_i13.MockFireMessaging(),
      registerFor: {_service_test});
  gh.singletonAsync<_i12.ILocalNotification>(
      () => _i57.LocalNotification.initialize(),
      registerFor: {_service});
  gh.singleton<_i16.Memory>(_i16.Memory());
  gh.singleton<_i58.MockSharedPref>(_i58.MockSharedPref(),
      registerFor: {_service_test});
  gh.singleton<_i18.PersonUseCase>(_i55.MockPersonUseCase(),
      registerFor: {_usecase_test});
  gh.singletonAsync<_i33.SharedPref>(() => _i33.SharedPref.initialize(),
      registerFor: {_service});
  return get;
}
