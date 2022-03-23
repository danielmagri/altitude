// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../common/app_logic.dart' as _i3;
import '../../common/domain/usecases/competitions/get_competition_usecase.dart'
    as _i36;
import '../../common/domain/usecases/competitions/get_competitions_usecase.dart'
    as _i37;
import '../../common/domain/usecases/friends/get_friends_usecase.dart' as _i11;
import '../../common/domain/usecases/habits/complete_habit_usecase.dart'
    as _i60;
import '../../common/domain/usecases/habits/get_habit_usecase.dart' as _i38;
import '../../common/domain/usecases/habits/get_habits_usecase.dart' as _i39;
import '../../common/domain/usecases/habits/max_habits_usecase.dart' as _i43;
import '../../common/domain/usecases/notifications/send_competition_notification_usecase.dart'
    as _i54;
import '../../common/domain/usecases/user/get_user_data_usecase.dart' as _i50;
import '../../common/domain/usecases/user/update_fcm_token_usecase.dart'
    as _i46;
import '../../common/shared_pref/shared_pref.dart' as _i13;
import '../../common/useCase/CompetitionUseCase.dart' as _i59;
import '../../common/useCase/HabitUseCase.dart' as _i51;
import '../../common/useCase/PersonUseCase.dart' as _i52;
import '../../feature/competitions/domain/usecases/create_competition_usecase.dart'
    as _i33;
import '../../feature/competitions/domain/usecases/decline_competition_request_usecase.dart'
    as _i5;
import '../../feature/competitions/domain/usecases/get_pending_competitions_usecase.dart'
    as _i12;
import '../../feature/competitions/domain/usecases/get_ranking_friends_usecase.dart'
    as _i15;
import '../../feature/competitions/domain/usecases/max_competitions_by_habit_usecase.dart'
    as _i41;
import '../../feature/competitions/domain/usecases/max_competitions_usecase.dart'
    as _i42;
import '../../feature/competitions/domain/usecases/remove_competitor_usecase.dart'
    as _i27;
import '../../feature/competitions/domain/usecases/update_competition_usecase.dart'
    as _i29;
import '../../feature/competitions/presentation/controllers/competition_controller.dart'
    as _i58;
import '../../feature/competitions/presentation/controllers/competition_details_controller.dart'
    as _i32;
import '../../feature/competitions/presentation/controllers/create_competition_controller.dart'
    as _i48;
import '../../feature/competitions/presentation/controllers/pending_competition_controller.dart'
    as _i44;
import '../../feature/friends/domain/usecases/accept_request_usecase.dart'
    as _i30;
import '../../feature/friends/domain/usecases/cancel_friend_request_usecase.dart'
    as _i31;
import '../../feature/friends/domain/usecases/decline_request_usecase.dart'
    as _i7;
import '../../feature/friends/domain/usecases/friend_request_usecase.dart'
    as _i35;
import '../../feature/friends/domain/usecases/get_pending_friends_usecase.dart'
    as _i14;
import '../../feature/friends/domain/usecases/remove_friend_usecase.dart'
    as _i28;
import '../../feature/friends/domain/usecases/search_email_usecase.dart'
    as _i53;
import '../../feature/friends/presentation/controllers/add_friend_controller.dart'
    as _i57;
import '../../feature/friends/presentation/controllers/friends_controller.dart'
    as _i61;
import '../../feature/friends/presentation/controllers/pending_friends_controller.dart'
    as _i45;
import '../../feature/habits/domain/usecases/add_habit_usecase.dart' as _i66;
import '../../feature/habits/domain/usecases/delete_habit_usecase.dart' as _i34;
import '../../feature/habits/domain/usecases/get_calendar_days_done_usecase.dart'
    as _i10;
import '../../feature/habits/domain/usecases/get_reminder_counter_usecase.dart'
    as _i62;
import '../../feature/habits/domain/usecases/has_competition_by_habit_usecase.dart'
    as _i40;
import '../../feature/habits/domain/usecases/update_habit_usecase.dart' as _i47;
import '../../feature/habits/domain/usecases/update_reminder_usecase.dart'
    as _i65;
import '../../feature/habits/presentation/controllers/add_habit_controller.dart'
    as _i69;
import '../../feature/habits/presentation/controllers/edit_alarm_controller.dart'
    as _i67;
import '../../feature/habits/presentation/controllers/edit_cue_controller.dart'
    as _i68;
import '../../feature/habits/presentation/controllers/edit_habit_controller.dart'
    as _i49;
import '../../feature/habits/presentation/controllers/habit_details_controller.dart'
    as _i63;
import '../../feature/home/presentation/controllers/home_controller.dart'
    as _i64;
import '../../feature/login/domain/usecases/auth_google_usecase.dart' as _i4;
import '../../feature/login/presentation/controllers/login_controller.dart'
    as _i25;
import '../../feature/setting/presentation/controllers/settings_controller.dart'
    as _i55;
import '../../feature/statistics/presentation/controllers/statistics_controller.dart'
    as _i56;
import '../services/FireAnalytics.dart' as _i16;
import '../services/FireAuth.dart' as _i17;
import '../services/FireDatabase.dart' as _i18;
import '../services/FireFunctions.dart' as _i20;
import '../services/FireMenssaging.dart' as _i22;
import '../services/interfaces/i_fire_analytics.dart' as _i9;
import '../services/interfaces/i_fire_auth.dart' as _i8;
import '../services/interfaces/i_fire_database.dart' as _i6;
import '../services/interfaces/i_fire_functions.dart' as _i19;
import '../services/interfaces/i_fire_messaging.dart' as _i21;
import '../services/interfaces/i_local_notification.dart' as _i23;
import '../services/LocalNotification.dart' as _i24;
import '../services/Memory.dart' as _i26;

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
  gh.factory<_i10.GetCalendarDaysDoneUsecase>(
      () => _i10.GetCalendarDaysDoneUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i11.GetFriendsUsecase>(
      () => _i11.GetFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factoryAsync<_i12.GetPendingCompetitionsUsecase>(
      () async => _i12.GetPendingCompetitionsUsecase(
          get<_i6.IFireDatabase>(), await get.getAsync<_i13.SharedPref>()),
      registerFor: {_usecase});
  gh.factory<_i14.GetPendingFriendsUsecase>(
      () => _i14.GetPendingFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i15.GetRankingFriendsUsecase>(
      () => _i15.GetRankingFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.singleton<_i9.IFireAnalytics>(_i16.FireAnalytics(),
      registerFor: {_service});
  gh.factory<_i8.IFireAuth>(() => _i17.FireAuth(), registerFor: {_service});
  gh.factory<_i6.IFireDatabase>(() => _i18.FireDatabase(),
      registerFor: {_service});
  gh.factory<_i19.IFireFunctions>(() => _i20.FireFunctions(),
      registerFor: {_service});
  gh.factory<_i21.IFireMessaging>(() => _i22.FireMessaging(),
      registerFor: {_service});
  gh.singletonAsync<_i23.ILocalNotification>(
      () => _i24.LocalNotification.initialize(),
      registerFor: {_service});
  gh.lazySingleton<_i25.LoginController>(
      () => _i25.LoginController(get<_i4.AuthGoogleUsecase>()));
  gh.singleton<_i26.Memory>(_i26.Memory());
  gh.factory<_i27.RemoveCompetitorUsecase>(
      () => _i27.RemoveCompetitorUsecase(
          get<_i6.IFireDatabase>(), get<_i26.Memory>(), get<_i8.IFireAuth>()),
      registerFor: {_usecase});
  gh.factory<_i28.RemoveFriendUsecase>(
      () => _i28.RemoveFriendUsecase(
          get<_i6.IFireDatabase>(), get<_i8.IFireAuth>()),
      registerFor: {_usecase});
  gh.singletonAsync<_i13.SharedPref>(() => _i13.SharedPref.initialize(),
      registerFor: {_service});
  gh.factory<_i29.UpdateCompetitionUsecase>(
      () => _i29.UpdateCompetitionUsecase(
          get<_i6.IFireDatabase>(), get<_i26.Memory>()),
      registerFor: {_usecase});
  gh.factory<_i30.AcceptRequestUsecase>(
      () => _i30.AcceptRequestUsecase(
          get<_i6.IFireDatabase>(),
          get<_i8.IFireAuth>(),
          get<_i9.IFireAnalytics>(),
          get<_i26.Memory>(),
          get<_i19.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i31.CancelFriendRequestUsecase>(
      () => _i31.CancelFriendRequestUsecase(get<_i6.IFireDatabase>(),
          get<_i8.IFireAuth>(), get<_i9.IFireAnalytics>(), get<_i26.Memory>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i32.CompetitionDetailsController>(() =>
      _i32.CompetitionDetailsController(
          get<_i11.GetFriendsUsecase>(),
          get<_i27.RemoveCompetitorUsecase>(),
          get<_i29.UpdateCompetitionUsecase>()));
  gh.factory<_i33.CreateCompetitionUsecase>(
      () => _i33.CreateCompetitionUsecase(
          get<_i6.IFireDatabase>(),
          get<_i21.IFireMessaging>(),
          get<_i19.IFireFunctions>(),
          get<_i9.IFireAnalytics>(),
          get<_i8.IFireAuth>(),
          get<_i26.Memory>()),
      registerFor: {_usecase});
  gh.factoryAsync<_i34.DeleteHabitUsecase>(
      () async => _i34.DeleteHabitUsecase(
          get<_i26.Memory>(),
          get<_i6.IFireDatabase>(),
          await get.getAsync<_i23.ILocalNotification>(),
          get<_i9.IFireAnalytics>()),
      registerFor: {_usecase});
  gh.factory<_i35.FriendRequestUsecase>(
      () => _i35.FriendRequestUsecase(
          get<_i6.IFireDatabase>(),
          get<_i8.IFireAuth>(),
          get<_i9.IFireAnalytics>(),
          get<_i26.Memory>(),
          get<_i19.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i36.GetCompetitionUsecase>(
      () => _i36.GetCompetitionUsecase(
          get<_i26.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i37.GetCompetitionsUsecase>(
      () => _i37.GetCompetitionsUsecase(
          get<_i26.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i38.GetHabitUsecase>(
      () => _i38.GetHabitUsecase(get<_i26.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i39.GetHabitsUsecase>(
      () => _i39.GetHabitsUsecase(get<_i26.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i40.HasCompetitionByHabitUsecase>(
      () =>
          _i40.HasCompetitionByHabitUsecase(get<_i37.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i41.MaxCompetitionsByHabitUsecase>(
      () => _i41.MaxCompetitionsByHabitUsecase(
          get<_i37.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i42.MaxCompetitionsUsecase>(
      () => _i42.MaxCompetitionsUsecase(get<_i37.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i43.MaxHabitsUsecase>(
      () => _i43.MaxHabitsUsecase(get<_i39.GetHabitsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingletonAsync<_i44.PendingCompetitionController>(() async =>
      _i44.PendingCompetitionController(
          get<_i42.MaxCompetitionsUsecase>(),
          get<_i39.GetHabitsUsecase>(),
          await get.getAsync<_i13.SharedPref>(),
          await get.getAsync<_i12.GetPendingCompetitionsUsecase>(),
          get<_i5.DeclineCompetitionRequestUsecase>()));
  gh.lazySingletonAsync<_i45.PendingFriendsController>(() async =>
      _i45.PendingFriendsController(
          get<_i14.GetPendingFriendsUsecase>(),
          get<_i30.AcceptRequestUsecase>(),
          get<_i7.DeclineRequestUsecase>(),
          await get.getAsync<_i13.SharedPref>()));
  gh.factory<_i46.UpdateFCMTokenUsecase>(
      () => _i46.UpdateFCMTokenUsecase(
          get<_i21.IFireMessaging>(),
          get<_i6.IFireDatabase>(),
          get<_i26.Memory>(),
          get<_i37.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i47.UpdateHabitUsecase>(
      () => _i47.UpdateHabitUsecase(get<_i26.Memory>(),
          get<_i6.IFireDatabase>(), get<_i37.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i48.CreateCompetitionController>(() =>
      _i48.CreateCompetitionController(get<_i33.CreateCompetitionUsecase>(),
          get<_i41.MaxCompetitionsByHabitUsecase>()));
  gh.lazySingletonAsync<_i49.EditHabitController>(() async =>
      _i49.EditHabitController(get<_i47.UpdateHabitUsecase>(),
          await get.getAsync<_i34.DeleteHabitUsecase>()));
  gh.factory<_i50.GetUserDataUsecase>(
      () => _i50.GetUserDataUsecase(
          get<_i26.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i8.IFireAuth>(),
          get<_i21.IFireMessaging>(),
          get<_i46.UpdateFCMTokenUsecase>()),
      registerFor: {_usecase});
  gh.factoryAsync<_i51.HabitUseCase>(
      () async => _i51.HabitUseCase(
          get<_i26.Memory>(),
          get<_i6.IFireDatabase>(),
          await get.getAsync<_i23.ILocalNotification>(),
          get<_i9.IFireAnalytics>(),
          get<_i50.GetUserDataUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i52.PersonUseCase>(
      () => _i52.PersonUseCase(
          get<_i26.Memory>(),
          get<_i8.IFireAuth>(),
          get<_i21.IFireMessaging>(),
          get<_i6.IFireDatabase>(),
          get<_i50.GetUserDataUsecase>(),
          get<_i46.UpdateFCMTokenUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i53.SearchEmailUsecase>(
      () => _i53.SearchEmailUsecase(get<_i6.IFireDatabase>(),
          get<_i50.GetUserDataUsecase>(), get<_i8.IFireAuth>()),
      registerFor: {_usecase});
  gh.factory<_i54.SendCompetitionNotificationUsecase>(
      () => _i54.SendCompetitionNotificationUsecase(
          get<_i52.PersonUseCase>(), get<_i19.IFireFunctions>()),
      registerFor: {_usecase});
  gh.lazySingletonAsync<_i55.SettingsController>(() async =>
      _i55.SettingsController(
          get<_i52.PersonUseCase>(),
          await get.getAsync<_i51.HabitUseCase>(),
          await get.getAsync<_i13.SharedPref>(),
          get<_i37.GetCompetitionsUsecase>()));
  gh.lazySingletonAsync<_i56.StatisticsController>(() async =>
      _i56.StatisticsController(
          get<_i52.PersonUseCase>(),
          await get.getAsync<_i51.HabitUseCase>(),
          get<_i39.GetHabitsUsecase>()));
  gh.lazySingleton<_i57.AddFriendController>(() => _i57.AddFriendController(
      get<_i53.SearchEmailUsecase>(),
      get<_i35.FriendRequestUsecase>(),
      get<_i31.CancelFriendRequestUsecase>(),
      get<_i30.AcceptRequestUsecase>()));
  gh.lazySingletonAsync<_i58.CompetitionController>(() async =>
      _i58.CompetitionController(
          get<_i39.GetHabitsUsecase>(),
          get<_i15.GetRankingFriendsUsecase>(),
          get<_i50.GetUserDataUsecase>(),
          get<_i37.GetCompetitionsUsecase>(),
          get<_i36.GetCompetitionUsecase>(),
          get<_i42.MaxCompetitionsUsecase>(),
          await get.getAsync<_i13.SharedPref>(),
          get<_i27.RemoveCompetitorUsecase>(),
          get<_i11.GetFriendsUsecase>()));
  gh.factory<_i59.CompetitionUseCase>(
      () => _i59.CompetitionUseCase(
          get<_i26.Memory>(),
          get<_i52.PersonUseCase>(),
          get<_i6.IFireDatabase>(),
          get<_i19.IFireFunctions>(),
          get<_i36.GetCompetitionUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i60.CompleteHabitUsecase>(
      () => _i60.CompleteHabitUsecase(
          get<_i26.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i52.PersonUseCase>(),
          get<_i54.SendCompetitionNotificationUsecase>(),
          get<_i38.GetHabitUsecase>(),
          get<_i37.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingletonAsync<_i61.FriendsController>(() async =>
      _i61.FriendsController(
          get<_i11.GetFriendsUsecase>(),
          get<_i50.GetUserDataUsecase>(),
          get<_i28.RemoveFriendUsecase>(),
          await get.getAsync<_i13.SharedPref>()));
  gh.factory<_i62.GetReminderCounterUsecase>(
      () => _i62.GetReminderCounterUsecase(
          get<_i26.Memory>(), get<_i50.GetUserDataUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i63.HabitDetailsController>(() =>
      _i63.HabitDetailsController(
          get<_i60.CompleteHabitUsecase>(),
          get<_i38.GetHabitUsecase>(),
          get<_i40.HasCompetitionByHabitUsecase>(),
          get<_i10.GetCalendarDaysDoneUsecase>()));
  gh.lazySingleton<_i64.HomeController>(() => _i64.HomeController(
      get<_i39.GetHabitsUsecase>(),
      get<_i60.CompleteHabitUsecase>(),
      get<_i43.MaxHabitsUsecase>(),
      get<_i9.IFireAnalytics>(),
      get<_i3.AppLogic>(),
      get<_i52.PersonUseCase>(),
      get<_i59.CompetitionUseCase>(),
      get<_i50.GetUserDataUsecase>()));
  gh.factoryAsync<_i65.UpdateReminderUsecase>(
      () async => _i65.UpdateReminderUsecase(
          get<_i26.Memory>(),
          await get.getAsync<_i23.ILocalNotification>(),
          get<_i6.IFireDatabase>(),
          get<_i62.GetReminderCounterUsecase>()),
      registerFor: {_usecase});
  gh.factoryAsync<_i66.AddHabitUsecase>(
      () async => _i66.AddHabitUsecase(
          get<_i6.IFireDatabase>(),
          get<_i9.IFireAnalytics>(),
          get<_i26.Memory>(),
          await get.getAsync<_i23.ILocalNotification>(),
          get<_i62.GetReminderCounterUsecase>()),
      registerFor: {_usecase});
  gh.lazySingletonAsync<_i67.EditAlarmController>(() async =>
      _i67.EditAlarmController(
          get<_i63.HabitDetailsController>(),
          await get.getAsync<_i65.UpdateReminderUsecase>(),
          get<_i9.IFireAnalytics>()));
  gh.lazySingleton<_i68.EditCueController>(() => _i68.EditCueController(
      get<_i47.UpdateHabitUsecase>(),
      get<_i9.IFireAnalytics>(),
      get<_i63.HabitDetailsController>()));
  gh.lazySingletonAsync<_i69.AddHabitController>(() async =>
      _i69.AddHabitController(await get.getAsync<_i66.AddHabitUsecase>()));
  return get;
}
