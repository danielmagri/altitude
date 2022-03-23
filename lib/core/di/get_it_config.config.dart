// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../common/app_logic.dart' as _i3;
import '../../common/domain/usecases/competitions/get_competition_usecase.dart'
    as _i43;
import '../../common/domain/usecases/competitions/get_competitions_usecase.dart'
    as _i44;
import '../../common/domain/usecases/friends/get_friends_usecase.dart' as _i13;
import '../../common/domain/usecases/habits/complete_habit_usecase.dart'
    as _i67;
import '../../common/domain/usecases/habits/get_habit_usecase.dart' as _i45;
import '../../common/domain/usecases/habits/get_habits_usecase.dart' as _i46;
import '../../common/domain/usecases/habits/get_reminder_counter_usecase.dart'
    as _i70;
import '../../common/domain/usecases/habits/max_habits_usecase.dart' as _i51;
import '../../common/domain/usecases/notifications/send_competition_notification_usecase.dart'
    as _i61;
import '../../common/domain/usecases/user/get_user_data_usecase.dart' as _i58;
import '../../common/domain/usecases/user/is_logged_usecase.dart' as _i27;
import '../../common/domain/usecases/user/update_fcm_token_usecase.dart'
    as _i54;
import '../../common/shared_pref/shared_pref.dart' as _i15;
import '../../feature/competitions/domain/usecases/accept_competition_request_usecase.dart'
    as _i64;
import '../../feature/competitions/domain/usecases/create_competition_usecase.dart'
    as _i40;
import '../../feature/competitions/domain/usecases/decline_competition_request_usecase.dart'
    as _i5;
import '../../feature/competitions/domain/usecases/get_days_done_usecase.dart'
    as _i12;
import '../../feature/competitions/domain/usecases/get_pending_competitions_usecase.dart'
    as _i14;
import '../../feature/competitions/domain/usecases/get_ranking_friends_usecase.dart'
    as _i17;
import '../../feature/competitions/domain/usecases/invite_competitor_usecase.dart'
    as _i59;
import '../../feature/competitions/domain/usecases/max_competitions_by_habit_usecase.dart'
    as _i49;
import '../../feature/competitions/domain/usecases/max_competitions_usecase.dart'
    as _i50;
import '../../feature/competitions/domain/usecases/remove_competitor_usecase.dart'
    as _i31;
import '../../feature/competitions/domain/usecases/update_competition_usecase.dart'
    as _i33;
import '../../feature/competitions/presentation/controllers/competition_controller.dart'
    as _i66;
import '../../feature/competitions/presentation/controllers/competition_details_controller.dart'
    as _i39;
import '../../feature/competitions/presentation/controllers/create_competition_controller.dart'
    as _i56;
import '../../feature/competitions/presentation/controllers/pending_competition_controller.dart'
    as _i52;
import '../../feature/friends/domain/usecases/accept_request_usecase.dart'
    as _i37;
import '../../feature/friends/domain/usecases/cancel_friend_request_usecase.dart'
    as _i38;
import '../../feature/friends/domain/usecases/decline_request_usecase.dart'
    as _i7;
import '../../feature/friends/domain/usecases/friend_request_usecase.dart'
    as _i42;
import '../../feature/friends/domain/usecases/get_pending_friends_usecase.dart'
    as _i16;
import '../../feature/friends/domain/usecases/remove_friend_usecase.dart'
    as _i32;
import '../../feature/friends/domain/usecases/search_email_usecase.dart'
    as _i60;
import '../../feature/friends/presentation/controllers/add_friend_controller.dart'
    as _i65;
import '../../feature/friends/presentation/controllers/friends_controller.dart'
    as _i69;
import '../../feature/friends/presentation/controllers/pending_friends_controller.dart'
    as _i53;
import '../../feature/habits/domain/usecases/add_habit_usecase.dart' as _i75;
import '../../feature/habits/domain/usecases/delete_habit_usecase.dart' as _i41;
import '../../feature/habits/domain/usecases/get_calendar_days_done_usecase.dart'
    as _i11;
import '../../feature/habits/domain/usecases/has_competition_by_habit_usecase.dart'
    as _i47;
import '../../feature/habits/domain/usecases/update_habit_usecase.dart' as _i55;
import '../../feature/habits/domain/usecases/update_reminder_usecase.dart'
    as _i74;
import '../../feature/habits/presentation/controllers/add_habit_controller.dart'
    as _i78;
import '../../feature/habits/presentation/controllers/edit_alarm_controller.dart'
    as _i76;
import '../../feature/habits/presentation/controllers/edit_cue_controller.dart'
    as _i77;
import '../../feature/habits/presentation/controllers/edit_habit_controller.dart'
    as _i57;
import '../../feature/habits/presentation/controllers/habit_details_controller.dart'
    as _i71;
import '../../feature/home/domain/usecases/update_level_usecase.dart' as _i34;
import '../../feature/home/presentation/controllers/home_controller.dart'
    as _i72;
import '../../feature/login/domain/usecases/auth_google_usecase.dart' as _i4;
import '../../feature/login/presentation/controllers/login_controller.dart'
    as _i28;
import '../../feature/setting/domain/usecases/create_person_usecase.dart'
    as _i68;
import '../../feature/setting/domain/usecases/logout_usecase.dart' as _i48;
import '../../feature/setting/domain/usecases/recalculate_score_usecasse.dart'
    as _i30;
import '../../feature/setting/domain/usecases/transfer_habit_usecase.dart'
    as _i73;
import '../../feature/setting/domain/usecases/update_name_usecase.dart' as _i35;
import '../../feature/setting/domain/usecases/update_total_score_usecase.dart'
    as _i36;
import '../../feature/setting/presentation/controllers/settings_controller.dart'
    as _i62;
import '../../feature/statistics/domain/usecases/get_all_days_done_usecase.dart'
    as _i10;
import '../../feature/statistics/presentation/controllers/statistics_controller.dart'
    as _i63;
import '../services/FireAnalytics.dart' as _i18;
import '../services/FireAuth.dart' as _i19;
import '../services/FireDatabase.dart' as _i20;
import '../services/FireFunctions.dart' as _i22;
import '../services/FireMenssaging.dart' as _i24;
import '../services/interfaces/i_fire_analytics.dart' as _i9;
import '../services/interfaces/i_fire_auth.dart' as _i8;
import '../services/interfaces/i_fire_database.dart' as _i6;
import '../services/interfaces/i_fire_functions.dart' as _i21;
import '../services/interfaces/i_fire_messaging.dart' as _i23;
import '../services/interfaces/i_local_notification.dart' as _i25;
import '../services/LocalNotification.dart' as _i26;
import '../services/Memory.dart' as _i29;

const String _usecase = 'usecase';
const String _service = 'service';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.AppLogic>(_i3.AppLogic());
  gh.factory<_i4.AuthGoogleUsecase>(() => _i4.AuthGoogleUsecase(),
      registerFor: {_usecase});
  gh.factory<_i5.DeclineCompetitionRequestUsecase>(
      () => _i5.DeclineCompetitionRequestUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i7.DeclineRequestUsecase>(
      () => _i7.DeclineRequestUsecase(get<_i6.IFireDatabase>(),
          get<_i8.IFireAuth>(), get<_i9.IFireAnalytics>()),
      registerFor: {_usecase});
  gh.factory<_i10.GetAllDaysDoneUsecase>(
      () => _i10.GetAllDaysDoneUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i11.GetCalendarDaysDoneUsecase>(
      () => _i11.GetCalendarDaysDoneUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i12.GetDaysDoneUsecase>(
      () => _i12.GetDaysDoneUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i13.GetFriendsUsecase>(
      () => _i13.GetFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factoryAsync<_i14.GetPendingCompetitionsUsecase>(
      () async => _i14.GetPendingCompetitionsUsecase(
          get<_i6.IFireDatabase>(), await get.getAsync<_i15.SharedPref>()),
      registerFor: {_usecase});
  gh.factory<_i16.GetPendingFriendsUsecase>(
      () => _i16.GetPendingFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i17.GetRankingFriendsUsecase>(
      () => _i17.GetRankingFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.singleton<_i9.IFireAnalytics>(_i18.FireAnalytics(),
      registerFor: {_service});
  gh.factory<_i8.IFireAuth>(() => _i19.FireAuth(), registerFor: {_service});
  gh.factory<_i6.IFireDatabase>(() => _i20.FireDatabase(),
      registerFor: {_service});
  gh.factory<_i21.IFireFunctions>(() => _i22.FireFunctions(),
      registerFor: {_service});
  gh.factory<_i23.IFireMessaging>(() => _i24.FireMessaging(),
      registerFor: {_service});
  gh.singletonAsync<_i25.ILocalNotification>(
      () => _i26.LocalNotification.initialize(),
      registerFor: {_service});
  gh.factory<_i27.IsLoggedUsecase>(
      () => _i27.IsLoggedUsecase(get<_i8.IFireAuth>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i28.LoginController>(
      () => _i28.LoginController(get<_i4.AuthGoogleUsecase>()));
  gh.singleton<_i29.Memory>(_i29.Memory());
  gh.factory<_i30.RecalculateScoreUsecase>(
      () => _i30.RecalculateScoreUsecase(
          get<_i29.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i31.RemoveCompetitorUsecase>(
      () => _i31.RemoveCompetitorUsecase(
          get<_i6.IFireDatabase>(), get<_i29.Memory>(), get<_i8.IFireAuth>()),
      registerFor: {_usecase});
  gh.factory<_i32.RemoveFriendUsecase>(
      () => _i32.RemoveFriendUsecase(
          get<_i6.IFireDatabase>(), get<_i8.IFireAuth>()),
      registerFor: {_usecase});
  gh.singletonAsync<_i15.SharedPref>(() => _i15.SharedPref.initialize(),
      registerFor: {_service});
  gh.factory<_i33.UpdateCompetitionUsecase>(
      () => _i33.UpdateCompetitionUsecase(
          get<_i6.IFireDatabase>(), get<_i29.Memory>()),
      registerFor: {_usecase});
  gh.factory<_i34.UpdateLevelUsecase>(
      () =>
          _i34.UpdateLevelUsecase(get<_i6.IFireDatabase>(), get<_i29.Memory>()),
      registerFor: {_usecase});
  gh.factory<_i35.UpdateNameUsecase>(
      () => _i35.UpdateNameUsecase(
          get<_i29.Memory>(), get<_i8.IFireAuth>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i36.UpdateTotalScoreUsecase>(
      () => _i36.UpdateTotalScoreUsecase(
          get<_i29.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i37.AcceptRequestUsecase>(
      () => _i37.AcceptRequestUsecase(
          get<_i6.IFireDatabase>(),
          get<_i8.IFireAuth>(),
          get<_i9.IFireAnalytics>(),
          get<_i29.Memory>(),
          get<_i21.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i38.CancelFriendRequestUsecase>(
      () => _i38.CancelFriendRequestUsecase(get<_i6.IFireDatabase>(),
          get<_i8.IFireAuth>(), get<_i9.IFireAnalytics>(), get<_i29.Memory>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i39.CompetitionDetailsController>(() =>
      _i39.CompetitionDetailsController(
          get<_i13.GetFriendsUsecase>(),
          get<_i31.RemoveCompetitorUsecase>(),
          get<_i33.UpdateCompetitionUsecase>()));
  gh.factory<_i40.CreateCompetitionUsecase>(
      () => _i40.CreateCompetitionUsecase(
          get<_i6.IFireDatabase>(),
          get<_i23.IFireMessaging>(),
          get<_i21.IFireFunctions>(),
          get<_i9.IFireAnalytics>(),
          get<_i8.IFireAuth>(),
          get<_i29.Memory>()),
      registerFor: {_usecase});
  gh.factoryAsync<_i41.DeleteHabitUsecase>(
      () async => _i41.DeleteHabitUsecase(
          get<_i29.Memory>(),
          get<_i6.IFireDatabase>(),
          await get.getAsync<_i25.ILocalNotification>(),
          get<_i9.IFireAnalytics>()),
      registerFor: {_usecase});
  gh.factory<_i42.FriendRequestUsecase>(
      () => _i42.FriendRequestUsecase(
          get<_i6.IFireDatabase>(),
          get<_i8.IFireAuth>(),
          get<_i9.IFireAnalytics>(),
          get<_i29.Memory>(),
          get<_i21.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i43.GetCompetitionUsecase>(
      () => _i43.GetCompetitionUsecase(
          get<_i29.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i44.GetCompetitionsUsecase>(
      () => _i44.GetCompetitionsUsecase(
          get<_i29.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i45.GetHabitUsecase>(
      () => _i45.GetHabitUsecase(get<_i29.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i46.GetHabitsUsecase>(
      () => _i46.GetHabitsUsecase(get<_i29.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i47.HasCompetitionByHabitUsecase>(
      () =>
          _i47.HasCompetitionByHabitUsecase(get<_i44.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i48.LogoutUsecase>(
      () => _i48.LogoutUsecase(get<_i29.Memory>(), get<_i8.IFireAuth>()),
      registerFor: {_usecase});
  gh.factory<_i49.MaxCompetitionsByHabitUsecase>(
      () => _i49.MaxCompetitionsByHabitUsecase(
          get<_i44.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i50.MaxCompetitionsUsecase>(
      () => _i50.MaxCompetitionsUsecase(get<_i44.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i51.MaxHabitsUsecase>(
      () => _i51.MaxHabitsUsecase(get<_i46.GetHabitsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingletonAsync<_i52.PendingCompetitionController>(() async =>
      _i52.PendingCompetitionController(
          get<_i50.MaxCompetitionsUsecase>(),
          get<_i46.GetHabitsUsecase>(),
          await get.getAsync<_i15.SharedPref>(),
          await get.getAsync<_i14.GetPendingCompetitionsUsecase>(),
          get<_i5.DeclineCompetitionRequestUsecase>()));
  gh.lazySingletonAsync<_i53.PendingFriendsController>(() async =>
      _i53.PendingFriendsController(
          get<_i16.GetPendingFriendsUsecase>(),
          get<_i37.AcceptRequestUsecase>(),
          get<_i7.DeclineRequestUsecase>(),
          await get.getAsync<_i15.SharedPref>()));
  gh.factory<_i54.UpdateFCMTokenUsecase>(
      () => _i54.UpdateFCMTokenUsecase(
          get<_i23.IFireMessaging>(),
          get<_i6.IFireDatabase>(),
          get<_i29.Memory>(),
          get<_i44.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i55.UpdateHabitUsecase>(
      () => _i55.UpdateHabitUsecase(get<_i29.Memory>(),
          get<_i6.IFireDatabase>(), get<_i44.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i56.CreateCompetitionController>(() =>
      _i56.CreateCompetitionController(get<_i40.CreateCompetitionUsecase>(),
          get<_i49.MaxCompetitionsByHabitUsecase>()));
  gh.lazySingletonAsync<_i57.EditHabitController>(() async =>
      _i57.EditHabitController(get<_i55.UpdateHabitUsecase>(),
          await get.getAsync<_i41.DeleteHabitUsecase>()));
  gh.factory<_i58.GetUserDataUsecase>(
      () => _i58.GetUserDataUsecase(
          get<_i29.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i8.IFireAuth>(),
          get<_i23.IFireMessaging>(),
          get<_i54.UpdateFCMTokenUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i59.InviteCompetitorUsecase>(
      () => _i59.InviteCompetitorUsecase(
          get<_i43.GetCompetitionUsecase>(),
          get<_i58.GetUserDataUsecase>(),
          get<_i6.IFireDatabase>(),
          get<_i21.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i60.SearchEmailUsecase>(
      () => _i60.SearchEmailUsecase(get<_i6.IFireDatabase>(),
          get<_i58.GetUserDataUsecase>(), get<_i8.IFireAuth>()),
      registerFor: {_usecase});
  gh.factory<_i61.SendCompetitionNotificationUsecase>(
      () => _i61.SendCompetitionNotificationUsecase(
          get<_i58.GetUserDataUsecase>(), get<_i21.IFireFunctions>()),
      registerFor: {_usecase});
  gh.lazySingletonAsync<_i62.SettingsController>(() async =>
      _i62.SettingsController(
          await get.getAsync<_i15.SharedPref>(),
          get<_i44.GetCompetitionsUsecase>(),
          get<_i35.UpdateNameUsecase>(),
          get<_i48.LogoutUsecase>(),
          get<_i30.RecalculateScoreUsecase>(),
          get<_i27.IsLoggedUsecase>(),
          get<_i58.GetUserDataUsecase>()));
  gh.lazySingleton<_i63.StatisticsController>(() => _i63.StatisticsController(
      get<_i46.GetHabitsUsecase>(),
      get<_i58.GetUserDataUsecase>(),
      get<_i10.GetAllDaysDoneUsecase>()));
  gh.factory<_i64.AcceptCompetitionRequestUsecase>(
      () => _i64.AcceptCompetitionRequestUsecase(
          get<_i29.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i21.IFireFunctions>(),
          get<_i43.GetCompetitionUsecase>(),
          get<_i58.GetUserDataUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i65.AddFriendController>(() => _i65.AddFriendController(
      get<_i60.SearchEmailUsecase>(),
      get<_i42.FriendRequestUsecase>(),
      get<_i38.CancelFriendRequestUsecase>(),
      get<_i37.AcceptRequestUsecase>()));
  gh.lazySingletonAsync<_i66.CompetitionController>(() async =>
      _i66.CompetitionController(
          get<_i46.GetHabitsUsecase>(),
          get<_i17.GetRankingFriendsUsecase>(),
          get<_i58.GetUserDataUsecase>(),
          get<_i44.GetCompetitionsUsecase>(),
          get<_i43.GetCompetitionUsecase>(),
          get<_i50.MaxCompetitionsUsecase>(),
          await get.getAsync<_i15.SharedPref>(),
          get<_i31.RemoveCompetitorUsecase>(),
          get<_i13.GetFriendsUsecase>()));
  gh.factory<_i67.CompleteHabitUsecase>(
      () => _i67.CompleteHabitUsecase(
          get<_i29.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i58.GetUserDataUsecase>(),
          get<_i61.SendCompetitionNotificationUsecase>(),
          get<_i45.GetHabitUsecase>(),
          get<_i44.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i68.CreatePersonUsecase>(
      () => _i68.CreatePersonUsecase(
          get<_i29.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i8.IFireAuth>(),
          get<_i23.IFireMessaging>(),
          get<_i58.GetUserDataUsecase>(),
          get<_i54.UpdateFCMTokenUsecase>()),
      registerFor: {_usecase});
  gh.lazySingletonAsync<_i69.FriendsController>(() async =>
      _i69.FriendsController(
          get<_i13.GetFriendsUsecase>(),
          get<_i58.GetUserDataUsecase>(),
          get<_i32.RemoveFriendUsecase>(),
          await get.getAsync<_i15.SharedPref>()));
  gh.factory<_i70.GetReminderCounterUsecase>(
      () => _i70.GetReminderCounterUsecase(
          get<_i29.Memory>(), get<_i58.GetUserDataUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i71.HabitDetailsController>(() =>
      _i71.HabitDetailsController(
          get<_i67.CompleteHabitUsecase>(),
          get<_i45.GetHabitUsecase>(),
          get<_i47.HasCompetitionByHabitUsecase>(),
          get<_i11.GetCalendarDaysDoneUsecase>()));
  gh.lazySingletonAsync<_i72.HomeController>(() async => _i72.HomeController(
      get<_i46.GetHabitsUsecase>(),
      get<_i67.CompleteHabitUsecase>(),
      get<_i51.MaxHabitsUsecase>(),
      get<_i9.IFireAnalytics>(),
      get<_i3.AppLogic>(),
      get<_i58.GetUserDataUsecase>(),
      get<_i34.UpdateLevelUsecase>(),
      await get.getAsync<_i15.SharedPref>()));
  gh.factoryAsync<_i73.TransferHabitUsecase>(
      () async => _i73.TransferHabitUsecase(
          get<_i6.IFireDatabase>(),
          await get.getAsync<_i25.ILocalNotification>(),
          get<_i70.GetReminderCounterUsecase>()),
      registerFor: {_usecase});
  gh.factoryAsync<_i74.UpdateReminderUsecase>(
      () async => _i74.UpdateReminderUsecase(
          get<_i29.Memory>(),
          await get.getAsync<_i25.ILocalNotification>(),
          get<_i6.IFireDatabase>(),
          get<_i70.GetReminderCounterUsecase>()),
      registerFor: {_usecase});
  gh.factoryAsync<_i75.AddHabitUsecase>(
      () async => _i75.AddHabitUsecase(
          get<_i6.IFireDatabase>(),
          get<_i9.IFireAnalytics>(),
          get<_i29.Memory>(),
          await get.getAsync<_i25.ILocalNotification>(),
          get<_i70.GetReminderCounterUsecase>()),
      registerFor: {_usecase});
  gh.lazySingletonAsync<_i76.EditAlarmController>(() async =>
      _i76.EditAlarmController(
          get<_i71.HabitDetailsController>(),
          await get.getAsync<_i74.UpdateReminderUsecase>(),
          get<_i9.IFireAnalytics>()));
  gh.lazySingleton<_i77.EditCueController>(() => _i77.EditCueController(
      get<_i55.UpdateHabitUsecase>(),
      get<_i9.IFireAnalytics>(),
      get<_i71.HabitDetailsController>()));
  gh.lazySingletonAsync<_i78.AddHabitController>(() async =>
      _i78.AddHabitController(await get.getAsync<_i75.AddHabitUsecase>()));
  return get;
}
