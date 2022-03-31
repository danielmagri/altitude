// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/repository/competitions_repository.dart' as _i45;
import '../../data/repository/friends_repository.dart' as _i15;
import '../../data/repository/habits_repository.dart' as _i46;
import '../../data/repository/notifications_repository.dart' as _i18;
import '../../data/repository/user_repository.dart' as _i47;
import '../../domain/usecases/auth/auth_google_usecase.dart' as _i4;
import '../../domain/usecases/auth/logout_usecase.dart' as _i49;
import '../../domain/usecases/competitions/accept_competition_request_usecase.dart'
    as _i73;
import '../../domain/usecases/competitions/create_competition_usecase.dart'
    as _i33;
import '../../domain/usecases/competitions/decline_competition_request_usecase.dart'
    as _i34;
import '../../domain/usecases/competitions/get_competition_usecase.dart'
    as _i55;
import '../../domain/usecases/competitions/get_competitions_usecase.dart'
    as _i56;
import '../../domain/usecases/competitions/get_pending_competitions_usecase.dart'
    as _i42;
import '../../domain/usecases/competitions/has_competition_by_habit_usecase.dart'
    as _i61;
import '../../domain/usecases/competitions/invite_competitor_usecase.dart'
    as _i63;
import '../../domain/usecases/competitions/max_competitions_by_habit_usecase.dart'
    as _i64;
import '../../domain/usecases/competitions/max_competitions_usecase.dart'
    as _i65;
import '../../domain/usecases/competitions/remove_competitor_usecase.dart'
    as _i24;
import '../../domain/usecases/competitions/update_competition_usecase.dart'
    as _i27;
import '../../domain/usecases/friends/accept_request_usecase.dart' as _i31;
import '../../domain/usecases/friends/cancel_friend_request_usecase.dart'
    as _i32;
import '../../domain/usecases/friends/decline_request_usecase.dart' as _i35;
import '../../domain/usecases/friends/friend_request_usecase.dart' as _i37;
import '../../domain/usecases/friends/get_friends_usecase.dart' as _i41;
import '../../domain/usecases/friends/get_pending_friends_usecase.dart' as _i43;
import '../../domain/usecases/friends/get_ranking_friends_usecase.dart' as _i44;
import '../../domain/usecases/friends/remove_friend_usecase.dart' as _i25;
import '../../domain/usecases/friends/search_email_usecase.dart' as _i67;
import '../../domain/usecases/habits/add_habit_usecase.dart' as _i75;
import '../../domain/usecases/habits/complete_habit_usecase.dart' as _i54;
import '../../domain/usecases/habits/delete_habit_usecase.dart' as _i36;
import '../../domain/usecases/habits/get_all_days_done_usecase.dart' as _i38;
import '../../domain/usecases/habits/get_calendar_days_done_usecase.dart'
    as _i39;
import '../../domain/usecases/habits/get_days_done_usecase.dart' as _i40;
import '../../domain/usecases/habits/get_habit_usecase.dart' as _i57;
import '../../domain/usecases/habits/get_habits_usecase.dart' as _i58;
import '../../domain/usecases/habits/get_reminder_counter_usecase.dart' as _i59;
import '../../domain/usecases/habits/max_habits_usecase.dart' as _i50;
import '../../domain/usecases/habits/transfer_habit_usecase.dart' as _i70;
import '../../domain/usecases/habits/update_habit_usecase.dart' as _i71;
import '../../domain/usecases/habits/update_reminder_usecase.dart' as _i72;
import '../../domain/usecases/user/create_person_usecase.dart' as _i78;
import '../../domain/usecases/user/get_user_data_usecase.dart' as _i60;
import '../../domain/usecases/user/is_logged_usecase.dart' as _i48;
import '../../domain/usecases/user/recalculate_score_usecasse.dart' as _i23;
import '../../domain/usecases/user/update_fcm_token_usecase.dart' as _i52;
import '../../domain/usecases/user/update_level_usecase.dart' as _i28;
import '../../domain/usecases/user/update_name_usecase.dart' as _i29;
import '../../domain/usecases/user/update_total_score_usecase.dart' as _i30;
import '../../infra/interface/i_fire_analytics.dart' as _i5;
import '../../infra/interface/i_fire_auth.dart' as _i7;
import '../../infra/interface/i_fire_database.dart' as _i9;
import '../../infra/interface/i_fire_functions.dart' as _i11;
import '../../infra/interface/i_fire_messaging.dart' as _i13;
import '../../infra/interface/i_local_notification.dart' as _i16;
import '../../infra/interface/i_score_service.dart' as _i19;
import '../../infra/services/FireAnalytics.dart' as _i6;
import '../../infra/services/FireAuth.dart' as _i8;
import '../../infra/services/FireDatabase.dart' as _i10;
import '../../infra/services/FireFunctions.dart' as _i12;
import '../../infra/services/FireMenssaging.dart' as _i14;
import '../../infra/services/LocalNotification.dart' as _i17;
import '../../infra/services/Memory.dart' as _i22;
import '../../infra/services/score_service.dart' as _i20;
import '../../infra/services/shared_pref/shared_pref.dart' as _i26;
import '../../presentation/competitions/controllers/competition_controller.dart'
    as _i76;
import '../../presentation/competitions/controllers/competition_details_controller.dart'
    as _i53;
import '../../presentation/competitions/controllers/create_competition_controller.dart'
    as _i77;
import '../../presentation/competitions/controllers/pending_competition_controller.dart'
    as _i66;
import '../../presentation/friends/controllers/add_friend_controller.dart'
    as _i74;
import '../../presentation/friends/controllers/friends_controller.dart' as _i80;
import '../../presentation/friends/controllers/pending_friends_controller.dart'
    as _i51;
import '../../presentation/habits/controllers/add_habit_controller.dart'
    as _i82;
import '../../presentation/habits/controllers/edit_alarm_controller.dart'
    as _i83;
import '../../presentation/habits/controllers/edit_cue_controller.dart' as _i84;
import '../../presentation/habits/controllers/edit_habit_controller.dart'
    as _i79;
import '../../presentation/habits/controllers/habit_details_controller.dart'
    as _i81;
import '../../presentation/home/controllers/home_controller.dart' as _i62;
import '../../presentation/login/controllers/login_controller.dart' as _i21;
import '../../presentation/setting/controllers/settings_controller.dart'
    as _i68;
import '../../presentation/statistics/controllers/statistics_controller.dart'
    as _i69;
import '../app_logic.dart' as _i3; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.AppLogic>(_i3.AppLogic());
  gh.factory<_i4.AuthGoogleUsecase>(() => _i4.AuthGoogleUsecase());
  gh.factory<_i5.IFireAnalytics>(() => _i6.FireAnalytics());
  gh.factory<_i7.IFireAuth>(() => _i8.FireAuth());
  gh.factory<_i9.IFireDatabase>(() => _i10.FireDatabase());
  gh.factory<_i11.IFireFunctions>(() => _i12.FireFunctions());
  gh.factory<_i13.IFireMessaging>(() => _i14.FireMessaging());
  gh.factory<_i15.IFriendsRepository>(
      () => _i15.FriendsRepository(get<_i9.IFireDatabase>()));
  gh.singletonAsync<_i16.ILocalNotification>(
      () => _i17.LocalNotification.initialize());
  gh.factory<_i18.INotificationsRepository>(
      () => _i18.NotificationsRepository(get<_i11.IFireFunctions>()));
  gh.factory<_i19.IScoreService>(() => _i20.ScoreService());
  gh.lazySingleton<_i21.LoginController>(
      () => _i21.LoginController(get<_i4.AuthGoogleUsecase>()));
  gh.singleton<_i22.Memory>(_i22.Memory());
  gh.factory<_i23.RecalculateScoreUsecase>(() => _i23.RecalculateScoreUsecase(
      get<_i22.Memory>(), get<_i9.IFireDatabase>(), get<_i19.IScoreService>()));
  gh.factory<_i24.RemoveCompetitorUsecase>(() => _i24.RemoveCompetitorUsecase(
      get<_i9.IFireDatabase>(), get<_i22.Memory>(), get<_i7.IFireAuth>()));
  gh.factory<_i25.RemoveFriendUsecase>(() =>
      _i25.RemoveFriendUsecase(get<_i9.IFireDatabase>(), get<_i7.IFireAuth>()));
  await gh.singletonAsync<_i26.SharedPref>(() => _i26.SharedPref.initialize(),
      preResolve: true);
  gh.factory<_i27.UpdateCompetitionUsecase>(() => _i27.UpdateCompetitionUsecase(
      get<_i9.IFireDatabase>(), get<_i22.Memory>()));
  gh.factory<_i28.UpdateLevelUsecase>(() =>
      _i28.UpdateLevelUsecase(get<_i9.IFireDatabase>(), get<_i22.Memory>()));
  gh.factory<_i29.UpdateNameUsecase>(() => _i29.UpdateNameUsecase(
      get<_i22.Memory>(), get<_i7.IFireAuth>(), get<_i9.IFireDatabase>()));
  gh.factory<_i30.UpdateTotalScoreUsecase>(() => _i30.UpdateTotalScoreUsecase(
      get<_i22.Memory>(), get<_i9.IFireDatabase>()));
  gh.factory<_i31.AcceptRequestUsecase>(() => _i31.AcceptRequestUsecase(
      get<_i9.IFireDatabase>(),
      get<_i7.IFireAuth>(),
      get<_i5.IFireAnalytics>(),
      get<_i22.Memory>(),
      get<_i11.IFireFunctions>()));
  gh.factory<_i32.CancelFriendRequestUsecase>(() =>
      _i32.CancelFriendRequestUsecase(get<_i9.IFireDatabase>(),
          get<_i7.IFireAuth>(), get<_i5.IFireAnalytics>(), get<_i22.Memory>()));
  gh.factory<_i33.CreateCompetitionUsecase>(() => _i33.CreateCompetitionUsecase(
      get<_i9.IFireDatabase>(),
      get<_i13.IFireMessaging>(),
      get<_i11.IFireFunctions>(),
      get<_i5.IFireAnalytics>(),
      get<_i7.IFireAuth>(),
      get<_i22.Memory>()));
  gh.factory<_i34.DeclineCompetitionRequestUsecase>(
      () => _i34.DeclineCompetitionRequestUsecase(get<_i9.IFireDatabase>()));
  gh.factory<_i35.DeclineRequestUsecase>(() => _i35.DeclineRequestUsecase(
      get<_i9.IFireDatabase>(),
      get<_i7.IFireAuth>(),
      get<_i5.IFireAnalytics>()));
  gh.factoryAsync<_i36.DeleteHabitUsecase>(() async => _i36.DeleteHabitUsecase(
      get<_i22.Memory>(),
      get<_i9.IFireDatabase>(),
      await get.getAsync<_i16.ILocalNotification>(),
      get<_i5.IFireAnalytics>()));
  gh.factory<_i37.FriendRequestUsecase>(() => _i37.FriendRequestUsecase(
      get<_i9.IFireDatabase>(),
      get<_i7.IFireAuth>(),
      get<_i5.IFireAnalytics>(),
      get<_i22.Memory>(),
      get<_i11.IFireFunctions>()));
  gh.factory<_i38.GetAllDaysDoneUsecase>(
      () => _i38.GetAllDaysDoneUsecase(get<_i9.IFireDatabase>()));
  gh.factory<_i39.GetCalendarDaysDoneUsecase>(
      () => _i39.GetCalendarDaysDoneUsecase(get<_i9.IFireDatabase>()));
  gh.factory<_i40.GetDaysDoneUsecase>(
      () => _i40.GetDaysDoneUsecase(get<_i9.IFireDatabase>()));
  gh.factory<_i41.GetFriendsUsecase>(
      () => _i41.GetFriendsUsecase(get<_i15.IFriendsRepository>()));
  gh.factory<_i42.GetPendingCompetitionsUsecase>(() =>
      _i42.GetPendingCompetitionsUsecase(
          get<_i9.IFireDatabase>(), get<_i26.SharedPref>()));
  gh.factory<_i43.GetPendingFriendsUsecase>(
      () => _i43.GetPendingFriendsUsecase(get<_i9.IFireDatabase>()));
  gh.factory<_i44.GetRankingFriendsUsecase>(
      () => _i44.GetRankingFriendsUsecase(get<_i9.IFireDatabase>()));
  gh.factory<_i45.ICompetitionsRepository>(() => _i45.CompetitionsRepository(
      get<_i22.Memory>(), get<_i9.IFireDatabase>()));
  gh.factory<_i46.IHabitsRepository>(() => _i46.HabitsRepository(
      get<_i22.Memory>(), get<_i9.IFireDatabase>(), get<_i19.IScoreService>()));
  gh.factory<_i47.IUserRepository>(() => _i47.UserRepository(
      get<_i22.Memory>(),
      get<_i13.IFireMessaging>(),
      get<_i9.IFireDatabase>(),
      get<_i7.IFireAuth>()));
  gh.factory<_i48.IsLoggedUsecase>(
      () => _i48.IsLoggedUsecase(get<_i47.IUserRepository>()));
  gh.factory<_i49.LogoutUsecase>(
      () => _i49.LogoutUsecase(get<_i22.Memory>(), get<_i7.IFireAuth>()));
  gh.factory<_i50.MaxHabitsUsecase>(
      () => _i50.MaxHabitsUsecase(get<_i46.IHabitsRepository>()));
  gh.lazySingleton<_i51.PendingFriendsController>(() =>
      _i51.PendingFriendsController(
          get<_i43.GetPendingFriendsUsecase>(),
          get<_i31.AcceptRequestUsecase>(),
          get<_i35.DeclineRequestUsecase>(),
          get<_i26.SharedPref>()));
  gh.factory<_i52.UpdateFCMTokenUsecase>(
      () => _i52.UpdateFCMTokenUsecase(get<_i47.IUserRepository>()));
  gh.lazySingleton<_i53.CompetitionDetailsController>(() =>
      _i53.CompetitionDetailsController(
          get<_i41.GetFriendsUsecase>(),
          get<_i24.RemoveCompetitorUsecase>(),
          get<_i27.UpdateCompetitionUsecase>()));
  gh.factory<_i54.CompleteHabitUsecase>(() => _i54.CompleteHabitUsecase(
      get<_i46.IHabitsRepository>(),
      get<_i45.ICompetitionsRepository>(),
      get<_i18.INotificationsRepository>(),
      get<_i47.IUserRepository>()));
  gh.factory<_i55.GetCompetitionUsecase>(
      () => _i55.GetCompetitionUsecase(get<_i45.ICompetitionsRepository>()));
  gh.factory<_i56.GetCompetitionsUsecase>(
      () => _i56.GetCompetitionsUsecase(get<_i45.ICompetitionsRepository>()));
  gh.factory<_i57.GetHabitUsecase>(
      () => _i57.GetHabitUsecase(get<_i46.IHabitsRepository>()));
  gh.factory<_i58.GetHabitsUsecase>(
      () => _i58.GetHabitsUsecase(get<_i46.IHabitsRepository>()));
  gh.factory<_i59.GetReminderCounterUsecase>(
      () => _i59.GetReminderCounterUsecase(get<_i47.IUserRepository>()));
  gh.factory<_i60.GetUserDataUsecase>(
      () => _i60.GetUserDataUsecase(get<_i47.IUserRepository>()));
  gh.factory<_i61.HasCompetitionByHabitUsecase>(() =>
      _i61.HasCompetitionByHabitUsecase(get<_i56.GetCompetitionsUsecase>()));
  gh.lazySingleton<_i62.HomeController>(() => _i62.HomeController(
      get<_i58.GetHabitsUsecase>(),
      get<_i54.CompleteHabitUsecase>(),
      get<_i50.MaxHabitsUsecase>(),
      get<_i5.IFireAnalytics>(),
      get<_i3.AppLogic>(),
      get<_i60.GetUserDataUsecase>(),
      get<_i28.UpdateLevelUsecase>(),
      get<_i26.SharedPref>()));
  gh.factory<_i63.InviteCompetitorUsecase>(() => _i63.InviteCompetitorUsecase(
      get<_i55.GetCompetitionUsecase>(),
      get<_i60.GetUserDataUsecase>(),
      get<_i9.IFireDatabase>(),
      get<_i11.IFireFunctions>()));
  gh.factory<_i64.MaxCompetitionsByHabitUsecase>(() =>
      _i64.MaxCompetitionsByHabitUsecase(get<_i56.GetCompetitionsUsecase>()));
  gh.factory<_i65.MaxCompetitionsUsecase>(
      () => _i65.MaxCompetitionsUsecase(get<_i56.GetCompetitionsUsecase>()));
  gh.lazySingleton<_i66.PendingCompetitionController>(() =>
      _i66.PendingCompetitionController(
          get<_i65.MaxCompetitionsUsecase>(),
          get<_i58.GetHabitsUsecase>(),
          get<_i26.SharedPref>(),
          get<_i42.GetPendingCompetitionsUsecase>(),
          get<_i34.DeclineCompetitionRequestUsecase>()));
  gh.factory<_i67.SearchEmailUsecase>(() => _i67.SearchEmailUsecase(
      get<_i9.IFireDatabase>(),
      get<_i60.GetUserDataUsecase>(),
      get<_i7.IFireAuth>()));
  gh.lazySingleton<_i68.SettingsController>(() => _i68.SettingsController(
      get<_i26.SharedPref>(),
      get<_i56.GetCompetitionsUsecase>(),
      get<_i29.UpdateNameUsecase>(),
      get<_i49.LogoutUsecase>(),
      get<_i23.RecalculateScoreUsecase>(),
      get<_i48.IsLoggedUsecase>(),
      get<_i60.GetUserDataUsecase>()));
  gh.lazySingleton<_i69.StatisticsController>(() => _i69.StatisticsController(
      get<_i58.GetHabitsUsecase>(),
      get<_i60.GetUserDataUsecase>(),
      get<_i38.GetAllDaysDoneUsecase>(),
      get<_i19.IScoreService>()));
  gh.factoryAsync<_i70.TransferHabitUsecase>(() async =>
      _i70.TransferHabitUsecase(
          get<_i9.IFireDatabase>(),
          await get.getAsync<_i16.ILocalNotification>(),
          get<_i59.GetReminderCounterUsecase>()));
  gh.factory<_i71.UpdateHabitUsecase>(() => _i71.UpdateHabitUsecase(
      get<_i22.Memory>(),
      get<_i9.IFireDatabase>(),
      get<_i56.GetCompetitionsUsecase>()));
  gh.factoryAsync<_i72.UpdateReminderUsecase>(() async =>
      _i72.UpdateReminderUsecase(
          get<_i22.Memory>(),
          await get.getAsync<_i16.ILocalNotification>(),
          get<_i9.IFireDatabase>(),
          get<_i59.GetReminderCounterUsecase>()));
  gh.factory<_i73.AcceptCompetitionRequestUsecase>(() =>
      _i73.AcceptCompetitionRequestUsecase(
          get<_i22.Memory>(),
          get<_i9.IFireDatabase>(),
          get<_i11.IFireFunctions>(),
          get<_i55.GetCompetitionUsecase>(),
          get<_i60.GetUserDataUsecase>()));
  gh.lazySingleton<_i74.AddFriendController>(() => _i74.AddFriendController(
      get<_i67.SearchEmailUsecase>(),
      get<_i37.FriendRequestUsecase>(),
      get<_i32.CancelFriendRequestUsecase>(),
      get<_i31.AcceptRequestUsecase>()));
  gh.factoryAsync<_i75.AddHabitUsecase>(() async => _i75.AddHabitUsecase(
      get<_i9.IFireDatabase>(),
      get<_i5.IFireAnalytics>(),
      get<_i22.Memory>(),
      await get.getAsync<_i16.ILocalNotification>(),
      get<_i59.GetReminderCounterUsecase>()));
  gh.lazySingleton<_i76.CompetitionController>(() => _i76.CompetitionController(
      get<_i58.GetHabitsUsecase>(),
      get<_i44.GetRankingFriendsUsecase>(),
      get<_i60.GetUserDataUsecase>(),
      get<_i56.GetCompetitionsUsecase>(),
      get<_i55.GetCompetitionUsecase>(),
      get<_i65.MaxCompetitionsUsecase>(),
      get<_i26.SharedPref>(),
      get<_i24.RemoveCompetitorUsecase>(),
      get<_i41.GetFriendsUsecase>()));
  gh.lazySingleton<_i77.CreateCompetitionController>(() =>
      _i77.CreateCompetitionController(get<_i33.CreateCompetitionUsecase>(),
          get<_i64.MaxCompetitionsByHabitUsecase>()));
  gh.factory<_i78.CreatePersonUsecase>(() => _i78.CreatePersonUsecase(
      get<_i22.Memory>(),
      get<_i9.IFireDatabase>(),
      get<_i7.IFireAuth>(),
      get<_i13.IFireMessaging>(),
      get<_i60.GetUserDataUsecase>(),
      get<_i52.UpdateFCMTokenUsecase>()));
  gh.lazySingletonAsync<_i79.EditHabitController>(() async =>
      _i79.EditHabitController(get<_i71.UpdateHabitUsecase>(),
          await get.getAsync<_i36.DeleteHabitUsecase>()));
  gh.lazySingleton<_i80.FriendsController>(() => _i80.FriendsController(
      get<_i41.GetFriendsUsecase>(),
      get<_i60.GetUserDataUsecase>(),
      get<_i25.RemoveFriendUsecase>(),
      get<_i26.SharedPref>()));
  gh.lazySingleton<_i81.HabitDetailsController>(() =>
      _i81.HabitDetailsController(
          get<_i54.CompleteHabitUsecase>(),
          get<_i57.GetHabitUsecase>(),
          get<_i61.HasCompetitionByHabitUsecase>(),
          get<_i39.GetCalendarDaysDoneUsecase>()));
  gh.lazySingletonAsync<_i82.AddHabitController>(() async =>
      _i82.AddHabitController(await get.getAsync<_i75.AddHabitUsecase>()));
  gh.lazySingletonAsync<_i83.EditAlarmController>(() async =>
      _i83.EditAlarmController(
          get<_i81.HabitDetailsController>(),
          await get.getAsync<_i72.UpdateReminderUsecase>(),
          get<_i5.IFireAnalytics>()));
  gh.lazySingleton<_i84.EditCueController>(() => _i84.EditCueController(
      get<_i71.UpdateHabitUsecase>(),
      get<_i5.IFireAnalytics>(),
      get<_i81.HabitDetailsController>()));
  return get;
}
