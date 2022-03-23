// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../common/app_logic.dart' as _i3;
import '../../common/domain/usecases/competitions/get_competition_usecase.dart'
    as _i39;
import '../../common/domain/usecases/competitions/get_competitions_usecase.dart'
    as _i40;
import '../../common/domain/usecases/friends/get_friends_usecase.dart' as _i42;
import '../../common/domain/usecases/habits/complete_habit_usecase.dart'
    as _i69;
import '../../common/domain/usecases/habits/get_habit_usecase.dart' as _i43;
import '../../common/domain/usecases/habits/get_habits_usecase.dart' as _i44;
import '../../common/domain/usecases/habits/get_reminder_counter_usecase.dart'
    as _i72;
import '../../common/domain/usecases/habits/max_habits_usecase.dart' as _i52;
import '../../common/domain/usecases/notifications/send_competition_notification_usecase.dart'
    as _i63;
import '../../common/domain/usecases/user/get_user_data_usecase.dart' as _i60;
import '../../common/domain/usecases/user/is_logged_usecase.dart' as _i19;
import '../../common/domain/usecases/user/update_fcm_token_usecase.dart'
    as _i55;
import '../../common/infra/interface/i_score_service.dart' as _i17;
import '../../common/infra/services/score_service.dart' as _i18;
import '../../common/shared_pref/shared_pref.dart' as _i25;
import '../../feature/competitions/domain/usecases/accept_competition_request_usecase.dart'
    as _i66;
import '../../feature/competitions/domain/usecases/create_competition_usecase.dart'
    as _i32;
import '../../feature/competitions/domain/usecases/decline_competition_request_usecase.dart'
    as _i33;
import '../../feature/competitions/domain/usecases/get_days_done_usecase.dart'
    as _i41;
import '../../feature/competitions/domain/usecases/get_pending_competitions_usecase.dart'
    as _i45;
import '../../feature/competitions/domain/usecases/get_ranking_friends_usecase.dart'
    as _i47;
import '../../feature/competitions/domain/usecases/invite_competitor_usecase.dart'
    as _i61;
import '../../feature/competitions/domain/usecases/max_competitions_by_habit_usecase.dart'
    as _i50;
import '../../feature/competitions/domain/usecases/max_competitions_usecase.dart'
    as _i51;
import '../../feature/competitions/domain/usecases/remove_competitor_usecase.dart'
    as _i23;
import '../../feature/competitions/domain/usecases/update_competition_usecase.dart'
    as _i26;
import '../../feature/competitions/presentation/controllers/competition_controller.dart'
    as _i68;
import '../../feature/competitions/presentation/controllers/competition_details_controller.dart'
    as _i57;
import '../../feature/competitions/presentation/controllers/create_competition_controller.dart'
    as _i58;
import '../../feature/competitions/presentation/controllers/pending_competition_controller.dart'
    as _i53;
import '../../feature/friends/domain/usecases/accept_request_usecase.dart'
    as _i30;
import '../../feature/friends/domain/usecases/cancel_friend_request_usecase.dart'
    as _i31;
import '../../feature/friends/domain/usecases/decline_request_usecase.dart'
    as _i34;
import '../../feature/friends/domain/usecases/friend_request_usecase.dart'
    as _i36;
import '../../feature/friends/domain/usecases/get_pending_friends_usecase.dart'
    as _i46;
import '../../feature/friends/domain/usecases/remove_friend_usecase.dart'
    as _i24;
import '../../feature/friends/domain/usecases/search_email_usecase.dart'
    as _i62;
import '../../feature/friends/presentation/controllers/add_friend_controller.dart'
    as _i67;
import '../../feature/friends/presentation/controllers/friends_controller.dart'
    as _i71;
import '../../feature/friends/presentation/controllers/pending_friends_controller.dart'
    as _i54;
import '../../feature/habits/domain/usecases/add_habit_usecase.dart' as _i77;
import '../../feature/habits/domain/usecases/delete_habit_usecase.dart' as _i35;
import '../../feature/habits/domain/usecases/get_calendar_days_done_usecase.dart'
    as _i38;
import '../../feature/habits/domain/usecases/has_competition_by_habit_usecase.dart'
    as _i48;
import '../../feature/habits/domain/usecases/update_habit_usecase.dart' as _i56;
import '../../feature/habits/domain/usecases/update_reminder_usecase.dart'
    as _i76;
import '../../feature/habits/presentation/controllers/add_habit_controller.dart'
    as _i80;
import '../../feature/habits/presentation/controllers/edit_alarm_controller.dart'
    as _i78;
import '../../feature/habits/presentation/controllers/edit_cue_controller.dart'
    as _i79;
import '../../feature/habits/presentation/controllers/edit_habit_controller.dart'
    as _i59;
import '../../feature/habits/presentation/controllers/habit_details_controller.dart'
    as _i73;
import '../../feature/home/domain/usecases/update_level_usecase.dart' as _i27;
import '../../feature/home/presentation/controllers/home_controller.dart'
    as _i74;
import '../../feature/login/domain/usecases/auth_google_usecase.dart' as _i4;
import '../../feature/login/presentation/controllers/login_controller.dart'
    as _i20;
import '../../feature/setting/domain/usecases/create_person_usecase.dart'
    as _i70;
import '../../feature/setting/domain/usecases/logout_usecase.dart' as _i49;
import '../../feature/setting/domain/usecases/recalculate_score_usecasse.dart'
    as _i22;
import '../../feature/setting/domain/usecases/transfer_habit_usecase.dart'
    as _i75;
import '../../feature/setting/domain/usecases/update_name_usecase.dart' as _i28;
import '../../feature/setting/domain/usecases/update_total_score_usecase.dart'
    as _i29;
import '../../feature/setting/presentation/controllers/settings_controller.dart'
    as _i64;
import '../../feature/statistics/domain/usecases/get_all_days_done_usecase.dart'
    as _i37;
import '../../feature/statistics/presentation/controllers/statistics_controller.dart'
    as _i65;
import '../services/FireAnalytics.dart' as _i6;
import '../services/FireAuth.dart' as _i8;
import '../services/FireDatabase.dart' as _i10;
import '../services/FireFunctions.dart' as _i12;
import '../services/FireMenssaging.dart' as _i14;
import '../services/interfaces/i_fire_analytics.dart' as _i5;
import '../services/interfaces/i_fire_auth.dart' as _i7;
import '../services/interfaces/i_fire_database.dart' as _i9;
import '../services/interfaces/i_fire_functions.dart' as _i11;
import '../services/interfaces/i_fire_messaging.dart' as _i13;
import '../services/interfaces/i_local_notification.dart' as _i15;
import '../services/LocalNotification.dart' as _i16;
import '../services/Memory.dart'
    as _i21; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.AppLogic>(_i3.AppLogic());
  gh.factory<_i4.AuthGoogleUsecase>(() => _i4.AuthGoogleUsecase());
  gh.singleton<_i5.IFireAnalytics>(_i6.FireAnalytics());
  gh.factory<_i7.IFireAuth>(() => _i8.FireAuth());
  gh.factory<_i9.IFireDatabase>(() => _i10.FireDatabase());
  gh.factory<_i11.IFireFunctions>(() => _i12.FireFunctions());
  gh.factory<_i13.IFireMessaging>(() => _i14.FireMessaging());
  gh.singletonAsync<_i15.ILocalNotification>(
      () => _i16.LocalNotification.initialize());
  gh.factory<_i17.IScoreService>(() => _i18.ScoreService());
  gh.factory<_i19.IsLoggedUsecase>(
      () => _i19.IsLoggedUsecase(get<_i7.IFireAuth>()));
  gh.lazySingleton<_i20.LoginController>(
      () => _i20.LoginController(get<_i4.AuthGoogleUsecase>()));
  gh.singleton<_i21.Memory>(_i21.Memory());
  gh.factory<_i22.RecalculateScoreUsecase>(() => _i22.RecalculateScoreUsecase(
      get<_i21.Memory>(), get<_i9.IFireDatabase>(), get<_i17.IScoreService>()));
  gh.factory<_i23.RemoveCompetitorUsecase>(() => _i23.RemoveCompetitorUsecase(
      get<_i9.IFireDatabase>(), get<_i21.Memory>(), get<_i7.IFireAuth>()));
  gh.factory<_i24.RemoveFriendUsecase>(() =>
      _i24.RemoveFriendUsecase(get<_i9.IFireDatabase>(), get<_i7.IFireAuth>()));
  gh.singletonAsync<_i25.SharedPref>(() => _i25.SharedPref.initialize());
  gh.factory<_i26.UpdateCompetitionUsecase>(() => _i26.UpdateCompetitionUsecase(
      get<_i9.IFireDatabase>(), get<_i21.Memory>()));
  gh.factory<_i27.UpdateLevelUsecase>(() =>
      _i27.UpdateLevelUsecase(get<_i9.IFireDatabase>(), get<_i21.Memory>()));
  gh.factory<_i28.UpdateNameUsecase>(() => _i28.UpdateNameUsecase(
      get<_i21.Memory>(), get<_i7.IFireAuth>(), get<_i9.IFireDatabase>()));
  gh.factory<_i29.UpdateTotalScoreUsecase>(() => _i29.UpdateTotalScoreUsecase(
      get<_i21.Memory>(), get<_i9.IFireDatabase>()));
  gh.factory<_i30.AcceptRequestUsecase>(() => _i30.AcceptRequestUsecase(
      get<_i9.IFireDatabase>(),
      get<_i7.IFireAuth>(),
      get<_i5.IFireAnalytics>(),
      get<_i21.Memory>(),
      get<_i11.IFireFunctions>()));
  gh.factory<_i31.CancelFriendRequestUsecase>(() =>
      _i31.CancelFriendRequestUsecase(get<_i9.IFireDatabase>(),
          get<_i7.IFireAuth>(), get<_i5.IFireAnalytics>(), get<_i21.Memory>()));
  gh.factory<_i32.CreateCompetitionUsecase>(() => _i32.CreateCompetitionUsecase(
      get<_i9.IFireDatabase>(),
      get<_i13.IFireMessaging>(),
      get<_i11.IFireFunctions>(),
      get<_i5.IFireAnalytics>(),
      get<_i7.IFireAuth>(),
      get<_i21.Memory>()));
  gh.factory<_i33.DeclineCompetitionRequestUsecase>(
      () => _i33.DeclineCompetitionRequestUsecase(get<_i9.IFireDatabase>()));
  gh.factory<_i34.DeclineRequestUsecase>(() => _i34.DeclineRequestUsecase(
      get<_i9.IFireDatabase>(),
      get<_i7.IFireAuth>(),
      get<_i5.IFireAnalytics>()));
  gh.factoryAsync<_i35.DeleteHabitUsecase>(() async => _i35.DeleteHabitUsecase(
      get<_i21.Memory>(),
      get<_i9.IFireDatabase>(),
      await get.getAsync<_i15.ILocalNotification>(),
      get<_i5.IFireAnalytics>()));
  gh.factory<_i36.FriendRequestUsecase>(() => _i36.FriendRequestUsecase(
      get<_i9.IFireDatabase>(),
      get<_i7.IFireAuth>(),
      get<_i5.IFireAnalytics>(),
      get<_i21.Memory>(),
      get<_i11.IFireFunctions>()));
  gh.factory<_i37.GetAllDaysDoneUsecase>(
      () => _i37.GetAllDaysDoneUsecase(get<_i9.IFireDatabase>()));
  gh.factory<_i38.GetCalendarDaysDoneUsecase>(
      () => _i38.GetCalendarDaysDoneUsecase(get<_i9.IFireDatabase>()));
  gh.factory<_i39.GetCompetitionUsecase>(() =>
      _i39.GetCompetitionUsecase(get<_i21.Memory>(), get<_i9.IFireDatabase>()));
  gh.factory<_i40.GetCompetitionsUsecase>(() => _i40.GetCompetitionsUsecase(
      get<_i21.Memory>(), get<_i9.IFireDatabase>()));
  gh.factory<_i41.GetDaysDoneUsecase>(
      () => _i41.GetDaysDoneUsecase(get<_i9.IFireDatabase>()));
  gh.factory<_i42.GetFriendsUsecase>(
      () => _i42.GetFriendsUsecase(get<_i9.IFireDatabase>()));
  gh.factory<_i43.GetHabitUsecase>(
      () => _i43.GetHabitUsecase(get<_i21.Memory>(), get<_i9.IFireDatabase>()));
  gh.factory<_i44.GetHabitsUsecase>(() =>
      _i44.GetHabitsUsecase(get<_i21.Memory>(), get<_i9.IFireDatabase>()));
  gh.factoryAsync<_i45.GetPendingCompetitionsUsecase>(() async =>
      _i45.GetPendingCompetitionsUsecase(
          get<_i9.IFireDatabase>(), await get.getAsync<_i25.SharedPref>()));
  gh.factory<_i46.GetPendingFriendsUsecase>(
      () => _i46.GetPendingFriendsUsecase(get<_i9.IFireDatabase>()));
  gh.factory<_i47.GetRankingFriendsUsecase>(
      () => _i47.GetRankingFriendsUsecase(get<_i9.IFireDatabase>()));
  gh.factory<_i48.HasCompetitionByHabitUsecase>(() =>
      _i48.HasCompetitionByHabitUsecase(get<_i40.GetCompetitionsUsecase>()));
  gh.factory<_i49.LogoutUsecase>(
      () => _i49.LogoutUsecase(get<_i21.Memory>(), get<_i7.IFireAuth>()));
  gh.factory<_i50.MaxCompetitionsByHabitUsecase>(() =>
      _i50.MaxCompetitionsByHabitUsecase(get<_i40.GetCompetitionsUsecase>()));
  gh.factory<_i51.MaxCompetitionsUsecase>(
      () => _i51.MaxCompetitionsUsecase(get<_i40.GetCompetitionsUsecase>()));
  gh.factory<_i52.MaxHabitsUsecase>(
      () => _i52.MaxHabitsUsecase(get<_i44.GetHabitsUsecase>()));
  gh.lazySingletonAsync<_i53.PendingCompetitionController>(() async =>
      _i53.PendingCompetitionController(
          get<_i51.MaxCompetitionsUsecase>(),
          get<_i44.GetHabitsUsecase>(),
          await get.getAsync<_i25.SharedPref>(),
          await get.getAsync<_i45.GetPendingCompetitionsUsecase>(),
          get<_i33.DeclineCompetitionRequestUsecase>()));
  gh.lazySingletonAsync<_i54.PendingFriendsController>(() async =>
      _i54.PendingFriendsController(
          get<_i46.GetPendingFriendsUsecase>(),
          get<_i30.AcceptRequestUsecase>(),
          get<_i34.DeclineRequestUsecase>(),
          await get.getAsync<_i25.SharedPref>()));
  gh.factory<_i55.UpdateFCMTokenUsecase>(() => _i55.UpdateFCMTokenUsecase(
      get<_i13.IFireMessaging>(),
      get<_i9.IFireDatabase>(),
      get<_i21.Memory>(),
      get<_i40.GetCompetitionsUsecase>()));
  gh.factory<_i56.UpdateHabitUsecase>(() => _i56.UpdateHabitUsecase(
      get<_i21.Memory>(),
      get<_i9.IFireDatabase>(),
      get<_i40.GetCompetitionsUsecase>()));
  gh.lazySingleton<_i57.CompetitionDetailsController>(() =>
      _i57.CompetitionDetailsController(
          get<_i42.GetFriendsUsecase>(),
          get<_i23.RemoveCompetitorUsecase>(),
          get<_i26.UpdateCompetitionUsecase>()));
  gh.lazySingleton<_i58.CreateCompetitionController>(() =>
      _i58.CreateCompetitionController(get<_i32.CreateCompetitionUsecase>(),
          get<_i50.MaxCompetitionsByHabitUsecase>()));
  gh.lazySingletonAsync<_i59.EditHabitController>(() async =>
      _i59.EditHabitController(get<_i56.UpdateHabitUsecase>(),
          await get.getAsync<_i35.DeleteHabitUsecase>()));
  gh.factory<_i60.GetUserDataUsecase>(() => _i60.GetUserDataUsecase(
      get<_i21.Memory>(),
      get<_i9.IFireDatabase>(),
      get<_i7.IFireAuth>(),
      get<_i13.IFireMessaging>(),
      get<_i55.UpdateFCMTokenUsecase>()));
  gh.factory<_i61.InviteCompetitorUsecase>(() => _i61.InviteCompetitorUsecase(
      get<_i39.GetCompetitionUsecase>(),
      get<_i60.GetUserDataUsecase>(),
      get<_i9.IFireDatabase>(),
      get<_i11.IFireFunctions>()));
  gh.factory<_i62.SearchEmailUsecase>(() => _i62.SearchEmailUsecase(
      get<_i9.IFireDatabase>(),
      get<_i60.GetUserDataUsecase>(),
      get<_i7.IFireAuth>()));
  gh.factory<_i63.SendCompetitionNotificationUsecase>(() =>
      _i63.SendCompetitionNotificationUsecase(
          get<_i60.GetUserDataUsecase>(), get<_i11.IFireFunctions>()));
  gh.lazySingletonAsync<_i64.SettingsController>(() async =>
      _i64.SettingsController(
          await get.getAsync<_i25.SharedPref>(),
          get<_i40.GetCompetitionsUsecase>(),
          get<_i28.UpdateNameUsecase>(),
          get<_i49.LogoutUsecase>(),
          get<_i22.RecalculateScoreUsecase>(),
          get<_i19.IsLoggedUsecase>(),
          get<_i60.GetUserDataUsecase>()));
  gh.lazySingleton<_i65.StatisticsController>(() => _i65.StatisticsController(
      get<_i44.GetHabitsUsecase>(),
      get<_i60.GetUserDataUsecase>(),
      get<_i37.GetAllDaysDoneUsecase>(),
      get<_i17.IScoreService>()));
  gh.factory<_i66.AcceptCompetitionRequestUsecase>(() =>
      _i66.AcceptCompetitionRequestUsecase(
          get<_i21.Memory>(),
          get<_i9.IFireDatabase>(),
          get<_i11.IFireFunctions>(),
          get<_i39.GetCompetitionUsecase>(),
          get<_i60.GetUserDataUsecase>()));
  gh.lazySingleton<_i67.AddFriendController>(() => _i67.AddFriendController(
      get<_i62.SearchEmailUsecase>(),
      get<_i36.FriendRequestUsecase>(),
      get<_i31.CancelFriendRequestUsecase>(),
      get<_i30.AcceptRequestUsecase>()));
  gh.lazySingletonAsync<_i68.CompetitionController>(() async =>
      _i68.CompetitionController(
          get<_i44.GetHabitsUsecase>(),
          get<_i47.GetRankingFriendsUsecase>(),
          get<_i60.GetUserDataUsecase>(),
          get<_i40.GetCompetitionsUsecase>(),
          get<_i39.GetCompetitionUsecase>(),
          get<_i51.MaxCompetitionsUsecase>(),
          await get.getAsync<_i25.SharedPref>(),
          get<_i23.RemoveCompetitorUsecase>(),
          get<_i42.GetFriendsUsecase>()));
  gh.factory<_i69.CompleteHabitUsecase>(() => _i69.CompleteHabitUsecase(
      get<_i21.Memory>(),
      get<_i9.IFireDatabase>(),
      get<_i60.GetUserDataUsecase>(),
      get<_i63.SendCompetitionNotificationUsecase>(),
      get<_i43.GetHabitUsecase>(),
      get<_i40.GetCompetitionsUsecase>(),
      get<_i17.IScoreService>()));
  gh.factory<_i70.CreatePersonUsecase>(() => _i70.CreatePersonUsecase(
      get<_i21.Memory>(),
      get<_i9.IFireDatabase>(),
      get<_i7.IFireAuth>(),
      get<_i13.IFireMessaging>(),
      get<_i60.GetUserDataUsecase>(),
      get<_i55.UpdateFCMTokenUsecase>()));
  gh.lazySingletonAsync<_i71.FriendsController>(() async =>
      _i71.FriendsController(
          get<_i42.GetFriendsUsecase>(),
          get<_i60.GetUserDataUsecase>(),
          get<_i24.RemoveFriendUsecase>(),
          await get.getAsync<_i25.SharedPref>()));
  gh.factory<_i72.GetReminderCounterUsecase>(() =>
      _i72.GetReminderCounterUsecase(
          get<_i21.Memory>(), get<_i60.GetUserDataUsecase>()));
  gh.lazySingleton<_i73.HabitDetailsController>(() =>
      _i73.HabitDetailsController(
          get<_i69.CompleteHabitUsecase>(),
          get<_i43.GetHabitUsecase>(),
          get<_i48.HasCompetitionByHabitUsecase>(),
          get<_i38.GetCalendarDaysDoneUsecase>()));
  gh.lazySingletonAsync<_i74.HomeController>(() async => _i74.HomeController(
      get<_i44.GetHabitsUsecase>(),
      get<_i69.CompleteHabitUsecase>(),
      get<_i52.MaxHabitsUsecase>(),
      get<_i5.IFireAnalytics>(),
      get<_i3.AppLogic>(),
      get<_i60.GetUserDataUsecase>(),
      get<_i27.UpdateLevelUsecase>(),
      await get.getAsync<_i25.SharedPref>()));
  gh.factoryAsync<_i75.TransferHabitUsecase>(() async =>
      _i75.TransferHabitUsecase(
          get<_i9.IFireDatabase>(),
          await get.getAsync<_i15.ILocalNotification>(),
          get<_i72.GetReminderCounterUsecase>()));
  gh.factoryAsync<_i76.UpdateReminderUsecase>(() async =>
      _i76.UpdateReminderUsecase(
          get<_i21.Memory>(),
          await get.getAsync<_i15.ILocalNotification>(),
          get<_i9.IFireDatabase>(),
          get<_i72.GetReminderCounterUsecase>()));
  gh.factoryAsync<_i77.AddHabitUsecase>(() async => _i77.AddHabitUsecase(
      get<_i9.IFireDatabase>(),
      get<_i5.IFireAnalytics>(),
      get<_i21.Memory>(),
      await get.getAsync<_i15.ILocalNotification>(),
      get<_i72.GetReminderCounterUsecase>()));
  gh.lazySingletonAsync<_i78.EditAlarmController>(() async =>
      _i78.EditAlarmController(
          get<_i73.HabitDetailsController>(),
          await get.getAsync<_i76.UpdateReminderUsecase>(),
          get<_i5.IFireAnalytics>()));
  gh.lazySingleton<_i79.EditCueController>(() => _i79.EditCueController(
      get<_i56.UpdateHabitUsecase>(),
      get<_i5.IFireAnalytics>(),
      get<_i73.HabitDetailsController>()));
  gh.lazySingletonAsync<_i80.AddHabitController>(() async =>
      _i80.AddHabitController(await get.getAsync<_i77.AddHabitUsecase>()));
  return get;
}
