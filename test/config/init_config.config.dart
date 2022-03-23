// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:altitude/common/app_logic.dart' as _i3;
import 'package:altitude/common/domain/usecases/competitions/get_competition_usecase.dart'
    as _i42;
import 'package:altitude/common/domain/usecases/competitions/get_competitions_usecase.dart'
    as _i43;
import 'package:altitude/common/domain/usecases/friends/get_friends_usecase.dart'
    as _i13;
import 'package:altitude/common/domain/usecases/habits/complete_habit_usecase.dart'
    as _i63;
import 'package:altitude/common/domain/usecases/habits/get_habit_usecase.dart'
    as _i44;
import 'package:altitude/common/domain/usecases/habits/get_habits_usecase.dart'
    as _i45;
import 'package:altitude/common/domain/usecases/habits/max_habits_usecase.dart'
    as _i49;
import 'package:altitude/common/domain/usecases/notifications/send_competition_notification_usecase.dart'
    as _i60;
import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart'
    as _i58;
import 'package:altitude/common/domain/usecases/user/update_fcm_token_usecase.dart'
    as _i54;
import 'package:altitude/common/shared_pref/shared_pref.dart' as _i15;
import 'package:altitude/common/useCase/CompetitionUseCase.dart' as _i5;
import 'package:altitude/common/useCase/HabitUseCase.dart' as _i18;
import 'package:altitude/common/useCase/PersonUseCase.dart' as _i32;
import 'package:altitude/core/services/FireAnalytics.dart' as _i19;
import 'package:altitude/core/services/FireAuth.dart' as _i21;
import 'package:altitude/core/services/FireDatabase.dart' as _i22;
import 'package:altitude/core/services/FireFunctions.dart' as _i24;
import 'package:altitude/core/services/FireMenssaging.dart' as _i26;
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart'
    as _i11;
import 'package:altitude/core/services/interfaces/i_fire_auth.dart' as _i10;
import 'package:altitude/core/services/interfaces/i_fire_database.dart' as _i8;
import 'package:altitude/core/services/interfaces/i_fire_functions.dart'
    as _i23;
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart'
    as _i25;
import 'package:altitude/core/services/interfaces/i_local_notification.dart'
    as _i27;
import 'package:altitude/core/services/LocalNotification.dart' as _i28;
import 'package:altitude/core/services/Memory.dart' as _i30;
import 'package:altitude/feature/competitions/domain/usecases/create_competition_usecase.dart'
    as _i39;
import 'package:altitude/feature/competitions/domain/usecases/decline_competition_request_usecase.dart'
    as _i7;
import 'package:altitude/feature/competitions/domain/usecases/get_pending_competitions_usecase.dart'
    as _i14;
import 'package:altitude/feature/competitions/domain/usecases/get_ranking_friends_usecase.dart'
    as _i17;
import 'package:altitude/feature/competitions/domain/usecases/max_competitions_by_habit_usecase.dart'
    as _i47;
import 'package:altitude/feature/competitions/domain/usecases/max_competitions_usecase.dart'
    as _i48;
import 'package:altitude/feature/competitions/domain/usecases/remove_competitor_usecase.dart'
    as _i33;
import 'package:altitude/feature/competitions/domain/usecases/update_competition_usecase.dart'
    as _i35;
import 'package:altitude/feature/competitions/presentation/controllers/competition_controller.dart'
    as _i62;
import 'package:altitude/feature/competitions/presentation/controllers/competition_details_controller.dart'
    as _i38;
import 'package:altitude/feature/competitions/presentation/controllers/create_competition_controller.dart'
    as _i56;
import 'package:altitude/feature/competitions/presentation/controllers/pending_competition_controller.dart'
    as _i50;
import 'package:altitude/feature/friends/domain/usecases/accept_request_usecase.dart'
    as _i36;
import 'package:altitude/feature/friends/domain/usecases/cancel_friend_request_usecase.dart'
    as _i37;
import 'package:altitude/feature/friends/domain/usecases/decline_request_usecase.dart'
    as _i9;
import 'package:altitude/feature/friends/domain/usecases/friend_request_usecase.dart'
    as _i41;
import 'package:altitude/feature/friends/domain/usecases/get_pending_friends_usecase.dart'
    as _i16;
import 'package:altitude/feature/friends/domain/usecases/remove_friend_usecase.dart'
    as _i34;
import 'package:altitude/feature/friends/domain/usecases/search_email_usecase.dart'
    as _i59;
import 'package:altitude/feature/friends/presentation/controllers/add_friend_controller.dart'
    as _i61;
import 'package:altitude/feature/friends/presentation/controllers/friends_controller.dart'
    as _i64;
import 'package:altitude/feature/friends/presentation/controllers/pending_friends_controller.dart'
    as _i51;
import 'package:altitude/feature/habits/domain/usecases/add_habit_usecase.dart'
    as _i69;
import 'package:altitude/feature/habits/domain/usecases/delete_habit_usecase.dart'
    as _i40;
import 'package:altitude/feature/habits/domain/usecases/get_calendar_days_done_usecase.dart'
    as _i12;
import 'package:altitude/feature/habits/domain/usecases/get_reminder_counter_usecase.dart'
    as _i65;
import 'package:altitude/feature/habits/domain/usecases/has_competition_by_habit_usecase.dart'
    as _i46;
import 'package:altitude/feature/habits/domain/usecases/update_habit_usecase.dart'
    as _i55;
import 'package:altitude/feature/habits/domain/usecases/update_reminder_usecase.dart'
    as _i68;
import 'package:altitude/feature/habits/presentation/controllers/add_habit_controller.dart'
    as _i72;
import 'package:altitude/feature/habits/presentation/controllers/edit_alarm_controller.dart'
    as _i70;
import 'package:altitude/feature/habits/presentation/controllers/edit_cue_controller.dart'
    as _i71;
import 'package:altitude/feature/habits/presentation/controllers/edit_habit_controller.dart'
    as _i57;
import 'package:altitude/feature/habits/presentation/controllers/habit_details_controller.dart'
    as _i66;
import 'package:altitude/feature/home/presentation/controllers/home_controller.dart'
    as _i67;
import 'package:altitude/feature/login/domain/usecases/auth_google_usecase.dart'
    as _i4;
import 'package:altitude/feature/login/presentation/controllers/login_controller.dart'
    as _i29;
import 'package:altitude/feature/setting/presentation/controllers/settings_controller.dart'
    as _i52;
import 'package:altitude/feature/statistics/presentation/controllers/statistics_controller.dart'
    as _i53;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'mocks/services_mocks.dart' as _i20;
import 'mocks/shared_pref_mock.dart' as _i31;
import 'mocks/use_case_mocks.dart' as _i6;

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
  gh.singleton<_i3.AppLogic>(_i3.AppLogic());
  gh.factory<_i4.AuthGoogleUsecase>(() => _i4.AuthGoogleUsecase(),
      registerFor: {_usecase});
  gh.singleton<_i5.CompetitionUseCase>(_i6.MockCompetitionUseCase(),
      registerFor: {_usecase_test});
  gh.factory<_i7.DeclineCompetitionRequestUsecase>(
      () => _i7.DeclineCompetitionRequestUsecase(get<_i8.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i9.DeclineRequestUsecase>(
      () => _i9.DeclineRequestUsecase(get<_i8.IFireDatabase>(),
          get<_i10.IFireAuth>(), get<_i11.IFireAnalytics>()),
      registerFor: {_usecase});
  gh.factory<_i12.GetCalendarDaysDoneUsecase>(
      () => _i12.GetCalendarDaysDoneUsecase(get<_i8.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i13.GetFriendsUsecase>(
      () => _i13.GetFriendsUsecase(get<_i8.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factoryAsync<_i14.GetPendingCompetitionsUsecase>(
      () async => _i14.GetPendingCompetitionsUsecase(
          get<_i8.IFireDatabase>(), await get.getAsync<_i15.SharedPref>()),
      registerFor: {_usecase});
  gh.factory<_i16.GetPendingFriendsUsecase>(
      () => _i16.GetPendingFriendsUsecase(get<_i8.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i17.GetRankingFriendsUsecase>(
      () => _i17.GetRankingFriendsUsecase(get<_i8.IFireDatabase>()),
      registerFor: {_usecase});
  gh.singleton<_i18.HabitUseCase>(_i6.MockHabitUseCase(),
      registerFor: {_usecase_test});
  gh.singleton<_i11.IFireAnalytics>(_i19.FireAnalytics(),
      registerFor: {_service});
  gh.singleton<_i11.IFireAnalytics>(_i20.MockFireAnalytics(),
      registerFor: {_service_test});
  gh.singleton<_i10.IFireAuth>(_i20.MockFireAuth(),
      registerFor: {_service_test});
  gh.factory<_i10.IFireAuth>(() => _i21.FireAuth(), registerFor: {_service});
  gh.singleton<_i8.IFireDatabase>(_i20.MockFireDatabase(),
      registerFor: {_service_test});
  gh.factory<_i8.IFireDatabase>(() => _i22.FireDatabase(),
      registerFor: {_service});
  gh.singleton<_i23.IFireFunctions>(_i20.MockFireFunctions(),
      registerFor: {_service_test});
  gh.factory<_i23.IFireFunctions>(() => _i24.FireFunctions(),
      registerFor: {_service});
  gh.factory<_i25.IFireMessaging>(() => _i26.FireMessaging(),
      registerFor: {_service});
  gh.singleton<_i25.IFireMessaging>(_i20.MockFireMessaging(),
      registerFor: {_service_test});
  gh.lazySingleton<_i27.ILocalNotification>(() => _i20.MockLocalNotification(),
      registerFor: {_service_test});
  gh.singletonAsync<_i27.ILocalNotification>(
      () => _i28.LocalNotification.initialize(),
      registerFor: {_service});
  gh.lazySingleton<_i29.LoginController>(
      () => _i29.LoginController(get<_i4.AuthGoogleUsecase>()));
  gh.singleton<_i30.Memory>(_i30.Memory());
  gh.singleton<_i31.MockSharedPref>(_i31.MockSharedPref(),
      registerFor: {_service_test});
  gh.singleton<_i32.PersonUseCase>(_i6.MockPersonUseCase(),
      registerFor: {_usecase_test});
  gh.factory<_i33.RemoveCompetitorUsecase>(
      () => _i33.RemoveCompetitorUsecase(
          get<_i8.IFireDatabase>(), get<_i30.Memory>(), get<_i10.IFireAuth>()),
      registerFor: {_usecase});
  gh.factory<_i34.RemoveFriendUsecase>(
      () => _i34.RemoveFriendUsecase(
          get<_i8.IFireDatabase>(), get<_i10.IFireAuth>()),
      registerFor: {_usecase});
  gh.singletonAsync<_i15.SharedPref>(() => _i15.SharedPref.initialize(),
      registerFor: {_service});
  gh.factory<_i35.UpdateCompetitionUsecase>(
      () => _i35.UpdateCompetitionUsecase(
          get<_i8.IFireDatabase>(), get<_i30.Memory>()),
      registerFor: {_usecase});
  gh.factory<_i36.AcceptRequestUsecase>(
      () => _i36.AcceptRequestUsecase(
          get<_i8.IFireDatabase>(),
          get<_i10.IFireAuth>(),
          get<_i11.IFireAnalytics>(),
          get<_i30.Memory>(),
          get<_i23.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i37.CancelFriendRequestUsecase>(
      () => _i37.CancelFriendRequestUsecase(
          get<_i8.IFireDatabase>(),
          get<_i10.IFireAuth>(),
          get<_i11.IFireAnalytics>(),
          get<_i30.Memory>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i38.CompetitionDetailsController>(() =>
      _i38.CompetitionDetailsController(
          get<_i13.GetFriendsUsecase>(),
          get<_i33.RemoveCompetitorUsecase>(),
          get<_i35.UpdateCompetitionUsecase>()));
  gh.factory<_i39.CreateCompetitionUsecase>(
      () => _i39.CreateCompetitionUsecase(
          get<_i8.IFireDatabase>(),
          get<_i25.IFireMessaging>(),
          get<_i23.IFireFunctions>(),
          get<_i11.IFireAnalytics>(),
          get<_i10.IFireAuth>(),
          get<_i30.Memory>()),
      registerFor: {_usecase});
  gh.factory<_i40.DeleteHabitUsecase>(
      () => _i40.DeleteHabitUsecase(
          get<_i30.Memory>(),
          get<_i8.IFireDatabase>(),
          get<_i27.ILocalNotification>(),
          get<_i11.IFireAnalytics>()),
      registerFor: {_usecase});
  gh.factory<_i41.FriendRequestUsecase>(
      () => _i41.FriendRequestUsecase(
          get<_i8.IFireDatabase>(),
          get<_i10.IFireAuth>(),
          get<_i11.IFireAnalytics>(),
          get<_i30.Memory>(),
          get<_i23.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i42.GetCompetitionUsecase>(
      () => _i42.GetCompetitionUsecase(
          get<_i30.Memory>(), get<_i8.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i43.GetCompetitionsUsecase>(
      () => _i43.GetCompetitionsUsecase(
          get<_i30.Memory>(), get<_i8.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i44.GetHabitUsecase>(
      () => _i44.GetHabitUsecase(get<_i30.Memory>(), get<_i8.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i45.GetHabitsUsecase>(
      () => _i45.GetHabitsUsecase(get<_i30.Memory>(), get<_i8.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i46.HasCompetitionByHabitUsecase>(
      () =>
          _i46.HasCompetitionByHabitUsecase(get<_i43.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i47.MaxCompetitionsByHabitUsecase>(
      () => _i47.MaxCompetitionsByHabitUsecase(
          get<_i43.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i48.MaxCompetitionsUsecase>(
      () => _i48.MaxCompetitionsUsecase(get<_i43.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i49.MaxHabitsUsecase>(
      () => _i49.MaxHabitsUsecase(get<_i45.GetHabitsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingletonAsync<_i50.PendingCompetitionController>(() async =>
      _i50.PendingCompetitionController(
          get<_i48.MaxCompetitionsUsecase>(),
          get<_i45.GetHabitsUsecase>(),
          await get.getAsync<_i15.SharedPref>(),
          await get.getAsync<_i14.GetPendingCompetitionsUsecase>(),
          get<_i7.DeclineCompetitionRequestUsecase>()));
  gh.lazySingletonAsync<_i51.PendingFriendsController>(() async =>
      _i51.PendingFriendsController(
          get<_i16.GetPendingFriendsUsecase>(),
          get<_i36.AcceptRequestUsecase>(),
          get<_i9.DeclineRequestUsecase>(),
          await get.getAsync<_i15.SharedPref>()));
  gh.lazySingletonAsync<_i52.SettingsController>(() async =>
      _i52.SettingsController(
          get<_i32.PersonUseCase>(),
          get<_i18.HabitUseCase>(),
          await get.getAsync<_i15.SharedPref>(),
          get<_i43.GetCompetitionsUsecase>()));
  gh.lazySingleton<_i53.StatisticsController>(() => _i53.StatisticsController(
      get<_i32.PersonUseCase>(),
      get<_i18.HabitUseCase>(),
      get<_i45.GetHabitsUsecase>()));
  gh.factory<_i54.UpdateFCMTokenUsecase>(
      () => _i54.UpdateFCMTokenUsecase(
          get<_i25.IFireMessaging>(),
          get<_i8.IFireDatabase>(),
          get<_i30.Memory>(),
          get<_i43.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i55.UpdateHabitUsecase>(
      () => _i55.UpdateHabitUsecase(get<_i30.Memory>(),
          get<_i8.IFireDatabase>(), get<_i43.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i56.CreateCompetitionController>(() =>
      _i56.CreateCompetitionController(get<_i39.CreateCompetitionUsecase>(),
          get<_i47.MaxCompetitionsByHabitUsecase>()));
  gh.lazySingleton<_i57.EditHabitController>(() => _i57.EditHabitController(
      get<_i55.UpdateHabitUsecase>(), get<_i40.DeleteHabitUsecase>()));
  gh.factory<_i58.GetUserDataUsecase>(
      () => _i58.GetUserDataUsecase(
          get<_i30.Memory>(),
          get<_i8.IFireDatabase>(),
          get<_i10.IFireAuth>(),
          get<_i25.IFireMessaging>(),
          get<_i54.UpdateFCMTokenUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i18.HabitUseCase>(
      () => _i18.HabitUseCase(
          get<_i30.Memory>(),
          get<_i8.IFireDatabase>(),
          get<_i27.ILocalNotification>(),
          get<_i11.IFireAnalytics>(),
          get<_i58.GetUserDataUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i32.PersonUseCase>(
      () => _i32.PersonUseCase(
          get<_i30.Memory>(),
          get<_i10.IFireAuth>(),
          get<_i25.IFireMessaging>(),
          get<_i8.IFireDatabase>(),
          get<_i58.GetUserDataUsecase>(),
          get<_i54.UpdateFCMTokenUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i59.SearchEmailUsecase>(
      () => _i59.SearchEmailUsecase(get<_i8.IFireDatabase>(),
          get<_i58.GetUserDataUsecase>(), get<_i10.IFireAuth>()),
      registerFor: {_usecase});
  gh.factory<_i60.SendCompetitionNotificationUsecase>(
      () => _i60.SendCompetitionNotificationUsecase(
          get<_i32.PersonUseCase>(), get<_i23.IFireFunctions>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i61.AddFriendController>(() => _i61.AddFriendController(
      get<_i59.SearchEmailUsecase>(),
      get<_i41.FriendRequestUsecase>(),
      get<_i37.CancelFriendRequestUsecase>(),
      get<_i36.AcceptRequestUsecase>()));
  gh.lazySingletonAsync<_i62.CompetitionController>(() async =>
      _i62.CompetitionController(
          get<_i45.GetHabitsUsecase>(),
          get<_i17.GetRankingFriendsUsecase>(),
          get<_i58.GetUserDataUsecase>(),
          get<_i43.GetCompetitionsUsecase>(),
          get<_i42.GetCompetitionUsecase>(),
          get<_i48.MaxCompetitionsUsecase>(),
          await get.getAsync<_i15.SharedPref>(),
          get<_i33.RemoveCompetitorUsecase>(),
          get<_i13.GetFriendsUsecase>()));
  gh.factory<_i5.CompetitionUseCase>(
      () => _i5.CompetitionUseCase(
          get<_i30.Memory>(),
          get<_i32.PersonUseCase>(),
          get<_i8.IFireDatabase>(),
          get<_i23.IFireFunctions>(),
          get<_i42.GetCompetitionUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i63.CompleteHabitUsecase>(
      () => _i63.CompleteHabitUsecase(
          get<_i30.Memory>(),
          get<_i8.IFireDatabase>(),
          get<_i32.PersonUseCase>(),
          get<_i60.SendCompetitionNotificationUsecase>(),
          get<_i44.GetHabitUsecase>(),
          get<_i43.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingletonAsync<_i64.FriendsController>(() async =>
      _i64.FriendsController(
          get<_i13.GetFriendsUsecase>(),
          get<_i58.GetUserDataUsecase>(),
          get<_i34.RemoveFriendUsecase>(),
          await get.getAsync<_i15.SharedPref>()));
  gh.factory<_i65.GetReminderCounterUsecase>(
      () => _i65.GetReminderCounterUsecase(
          get<_i30.Memory>(), get<_i58.GetUserDataUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i66.HabitDetailsController>(() =>
      _i66.HabitDetailsController(
          get<_i63.CompleteHabitUsecase>(),
          get<_i44.GetHabitUsecase>(),
          get<_i46.HasCompetitionByHabitUsecase>(),
          get<_i12.GetCalendarDaysDoneUsecase>()));
  gh.lazySingleton<_i67.HomeController>(() => _i67.HomeController(
      get<_i45.GetHabitsUsecase>(),
      get<_i63.CompleteHabitUsecase>(),
      get<_i49.MaxHabitsUsecase>(),
      get<_i11.IFireAnalytics>(),
      get<_i3.AppLogic>(),
      get<_i32.PersonUseCase>(),
      get<_i5.CompetitionUseCase>(),
      get<_i58.GetUserDataUsecase>()));
  gh.factory<_i68.UpdateReminderUsecase>(
      () => _i68.UpdateReminderUsecase(
          get<_i30.Memory>(),
          get<_i27.ILocalNotification>(),
          get<_i8.IFireDatabase>(),
          get<_i65.GetReminderCounterUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i69.AddHabitUsecase>(
      () => _i69.AddHabitUsecase(
          get<_i8.IFireDatabase>(),
          get<_i11.IFireAnalytics>(),
          get<_i30.Memory>(),
          get<_i27.ILocalNotification>(),
          get<_i65.GetReminderCounterUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i70.EditAlarmController>(() => _i70.EditAlarmController(
      get<_i66.HabitDetailsController>(),
      get<_i68.UpdateReminderUsecase>(),
      get<_i11.IFireAnalytics>()));
  gh.lazySingleton<_i71.EditCueController>(() => _i71.EditCueController(
      get<_i55.UpdateHabitUsecase>(),
      get<_i11.IFireAnalytics>(),
      get<_i66.HabitDetailsController>()));
  gh.lazySingleton<_i72.AddHabitController>(
      () => _i72.AddHabitController(get<_i69.AddHabitUsecase>()));
  return get;
}
