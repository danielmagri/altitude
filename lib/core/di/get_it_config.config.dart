// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../common/app_logic.dart' as _i58;
import '../../common/domain/usecases/competitions/get_competition_usecase.dart'
    as _i24;
import '../../common/domain/usecases/competitions/get_competitions_usecase.dart'
    as _i25;
import '../../common/domain/usecases/friends/get_friends_usecase.dart' as _i26;
import '../../common/domain/usecases/habits/complete_habit_usecase.dart'
    as _i53;
import '../../common/domain/usecases/habits/get_habit_usecase.dart' as _i27;
import '../../common/domain/usecases/habits/get_habits_usecase.dart' as _i28;
import '../../common/domain/usecases/habits/max_habits_usecase.dart' as _i35;
import '../../common/domain/usecases/notifications/send_competition_notification_usecase.dart'
    as _i46;
import '../../common/domain/usecases/user/get_user_data_usecase.dart' as _i41;
import '../../common/domain/usecases/user/update_fcm_token_usecase.dart'
    as _i38;
import '../../common/shared_pref/shared_pref.dart' as _i30;
import '../../common/useCase/CompetitionUseCase.dart' as _i52;
import '../../common/useCase/HabitUseCase.dart' as _i42;
import '../../common/useCase/PersonUseCase.dart' as _i44;
import '../../feature/competitions/domain/usecases/create_competition_usecase.dart'
    as _i20;
import '../../feature/competitions/domain/usecases/decline_competition_request_usecase.dart'
    as _i21;
import '../../feature/competitions/domain/usecases/get_pending_competitions_usecase.dart'
    as _i29;
import '../../feature/competitions/domain/usecases/get_ranking_friends_usecase.dart'
    as _i32;
import '../../feature/competitions/domain/usecases/max_competitions_by_habit_usecase.dart'
    as _i33;
import '../../feature/competitions/domain/usecases/max_competitions_usecase.dart'
    as _i34;
import '../../feature/competitions/domain/usecases/remove_competitor_usecase.dart'
    as _i13;
import '../../feature/competitions/domain/usecases/update_competition_usecase.dart'
    as _i16;
import '../../feature/competitions/presentation/controllers/competition_controller.dart'
    as _i51;
import '../../feature/competitions/presentation/controllers/competition_details_controller.dart'
    as _i39;
import '../../feature/competitions/presentation/controllers/create_competition_controller.dart'
    as _i40;
import '../../feature/competitions/presentation/controllers/pending_competition_controller.dart'
    as _i36;
import '../../feature/friends/domain/usecases/accept_request_usecase.dart'
    as _i17;
import '../../feature/friends/domain/usecases/cancel_friend_request_usecase.dart'
    as _i19;
import '../../feature/friends/domain/usecases/decline_request_usecase.dart'
    as _i22;
import '../../feature/friends/domain/usecases/friend_request_usecase.dart'
    as _i23;
import '../../feature/friends/domain/usecases/get_pending_friends_usecase.dart'
    as _i31;
import '../../feature/friends/domain/usecases/remove_friend_usecase.dart'
    as _i15;
import '../../feature/friends/domain/usecases/search_email_usecase.dart'
    as _i45;
import '../../feature/friends/presentation/controllers/add_friend_controller.dart'
    as _i49;
import '../../feature/friends/presentation/controllers/friends_controller.dart'
    as _i55;
import '../../feature/friends/presentation/controllers/pending_friends_controller.dart'
    as _i37;
import '../../feature/habits/presentation/controllers/add_habit_controller.dart'
    as _i50;
import '../../feature/habits/presentation/controllers/edit_alarm_controller.dart'
    as _i59;
import '../../feature/habits/presentation/controllers/edit_cue_controller.dart'
    as _i60;
import '../../feature/habits/presentation/controllers/edit_habit_controller.dart'
    as _i54;
import '../../feature/habits/presentation/controllers/habit_details_controller.dart'
    as _i56;
import '../../feature/home/presentation/controllers/home_controller.dart'
    as _i57;
import '../../feature/login/domain/usecases/auth_google_usecase.dart' as _i3;
import '../../feature/login/presentation/controllers/login_controller.dart'
    as _i12;
import '../../feature/setting/presentation/controllers/settings_controller.dart'
    as _i47;
import '../../feature/statistics/presentation/controllers/statistics_controller.dart'
    as _i48;
import '../services/FireAnalytics.dart' as _i61;
import '../services/FireAuth.dart' as _i5;
import '../services/FireDatabase.dart' as _i7;
import '../services/FireFunctions.dart' as _i9;
import '../services/FireMenssaging.dart' as _i11;
import '../services/interfaces/i_fire_analytics.dart' as _i18;
import '../services/interfaces/i_fire_auth.dart' as _i4;
import '../services/interfaces/i_fire_database.dart' as _i6;
import '../services/interfaces/i_fire_functions.dart' as _i8;
import '../services/interfaces/i_fire_messaging.dart' as _i10;
import '../services/interfaces/i_local_notification.dart' as _i43;
import '../services/LocalNotification.dart' as _i62;
import '../services/Memory.dart' as _i14;

const String _usecase = 'usecase';
const String _service = 'service';
// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
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
  gh.lazySingleton<_i12.LoginController>(
      () => _i12.LoginController(get<_i3.AuthGoogleUsecase>()));
  gh.factory<_i13.RemoveCompetitorUsecase>(
      () => _i13.RemoveCompetitorUsecase(
          get<_i6.IFireDatabase>(), get<_i14.Memory>(), get<_i4.IFireAuth>()),
      registerFor: {_usecase});
  gh.factory<_i15.RemoveFriendUsecase>(
      () => _i15.RemoveFriendUsecase(
          get<_i6.IFireDatabase>(), get<_i4.IFireAuth>()),
      registerFor: {_usecase});
  gh.factory<_i16.UpdateCompetitionUsecase>(
      () => _i16.UpdateCompetitionUsecase(
          get<_i6.IFireDatabase>(), get<_i14.Memory>()),
      registerFor: {_usecase});
  gh.factory<_i17.AcceptRequestUsecase>(
      () => _i17.AcceptRequestUsecase(
          get<_i6.IFireDatabase>(),
          get<_i4.IFireAuth>(),
          get<_i18.IFireAnalytics>(),
          get<_i14.Memory>(),
          get<_i8.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i19.CancelFriendRequestUsecase>(
      () => _i19.CancelFriendRequestUsecase(get<_i6.IFireDatabase>(),
          get<_i4.IFireAuth>(), get<_i18.IFireAnalytics>(), get<_i14.Memory>()),
      registerFor: {_usecase});
  gh.factory<_i20.CreateCompetitionUsecase>(
      () => _i20.CreateCompetitionUsecase(
          get<_i6.IFireDatabase>(),
          get<_i10.IFireMessaging>(),
          get<_i8.IFireFunctions>(),
          get<_i18.IFireAnalytics>(),
          get<_i4.IFireAuth>(),
          get<_i14.Memory>()),
      registerFor: {_usecase});
  gh.factory<_i21.DeclineCompetitionRequestUsecase>(
      () => _i21.DeclineCompetitionRequestUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i22.DeclineRequestUsecase>(
      () => _i22.DeclineRequestUsecase(get<_i6.IFireDatabase>(),
          get<_i4.IFireAuth>(), get<_i18.IFireAnalytics>()),
      registerFor: {_usecase});
  gh.factory<_i23.FriendRequestUsecase>(
      () => _i23.FriendRequestUsecase(
          get<_i6.IFireDatabase>(),
          get<_i4.IFireAuth>(),
          get<_i18.IFireAnalytics>(),
          get<_i14.Memory>(),
          get<_i8.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i24.GetCompetitionUsecase>(
      () => _i24.GetCompetitionUsecase(
          get<_i14.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i25.GetCompetitionsUsecase>(
      () => _i25.GetCompetitionsUsecase(
          get<_i14.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i26.GetFriendsUsecase>(
      () => _i26.GetFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i27.GetHabitUsecase>(
      () => _i27.GetHabitUsecase(get<_i14.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i28.GetHabitsUsecase>(
      () => _i28.GetHabitsUsecase(get<_i14.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i29.GetPendingCompetitionsUsecase>(
      () => _i29.GetPendingCompetitionsUsecase(
          get<_i6.IFireDatabase>(), get<_i30.SharedPref>()),
      registerFor: {_usecase});
  gh.factory<_i31.GetPendingFriendsUsecase>(
      () => _i31.GetPendingFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i32.GetRankingFriendsUsecase>(
      () => _i32.GetRankingFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i33.MaxCompetitionsByHabitUsecase>(
      () => _i33.MaxCompetitionsByHabitUsecase(
          get<_i25.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i34.MaxCompetitionsUsecase>(
      () => _i34.MaxCompetitionsUsecase(get<_i25.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i35.MaxHabitsUsecase>(
      () => _i35.MaxHabitsUsecase(get<_i28.GetHabitsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i36.PendingCompetitionController>(() =>
      _i36.PendingCompetitionController(
          get<_i34.MaxCompetitionsUsecase>(),
          get<_i28.GetHabitsUsecase>(),
          get<_i30.SharedPref>(),
          get<_i29.GetPendingCompetitionsUsecase>(),
          get<_i21.DeclineCompetitionRequestUsecase>()));
  gh.lazySingleton<_i37.PendingFriendsController>(() =>
      _i37.PendingFriendsController(
          get<_i31.GetPendingFriendsUsecase>(),
          get<_i17.AcceptRequestUsecase>(),
          get<_i22.DeclineRequestUsecase>(),
          get<_i30.SharedPref>()));
  gh.factory<_i38.UpdateFCMTokenUsecase>(
      () => _i38.UpdateFCMTokenUsecase(
          get<_i10.IFireMessaging>(),
          get<_i6.IFireDatabase>(),
          get<_i14.Memory>(),
          get<_i25.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i39.CompetitionDetailsController>(() =>
      _i39.CompetitionDetailsController(
          get<_i26.GetFriendsUsecase>(),
          get<_i13.RemoveCompetitorUsecase>(),
          get<_i16.UpdateCompetitionUsecase>()));
  gh.lazySingleton<_i40.CreateCompetitionController>(() =>
      _i40.CreateCompetitionController(get<_i20.CreateCompetitionUsecase>(),
          get<_i33.MaxCompetitionsByHabitUsecase>()));
  gh.factory<_i41.GetUserDataUsecase>(
      () => _i41.GetUserDataUsecase(
          get<_i14.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i4.IFireAuth>(),
          get<_i10.IFireMessaging>(),
          get<_i38.UpdateFCMTokenUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i42.HabitUseCase>(
      () => _i42.HabitUseCase(
          get<_i14.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i43.ILocalNotification>(),
          get<_i18.IFireAnalytics>(),
          get<_i41.GetUserDataUsecase>(),
          get<_i25.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i44.PersonUseCase>(
      () => _i44.PersonUseCase(
          get<_i14.Memory>(),
          get<_i4.IFireAuth>(),
          get<_i10.IFireMessaging>(),
          get<_i6.IFireDatabase>(),
          get<_i41.GetUserDataUsecase>(),
          get<_i38.UpdateFCMTokenUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i45.SearchEmailUsecase>(
      () => _i45.SearchEmailUsecase(get<_i6.IFireDatabase>(),
          get<_i41.GetUserDataUsecase>(), get<_i4.IFireAuth>()),
      registerFor: {_usecase});
  gh.factory<_i46.SendCompetitionNotificationUsecase>(
      () => _i46.SendCompetitionNotificationUsecase(
          get<_i44.PersonUseCase>(), get<_i8.IFireFunctions>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i47.SettingsController>(() => _i47.SettingsController(
      get<_i44.PersonUseCase>(),
      get<_i42.HabitUseCase>(),
      get<_i30.SharedPref>(),
      get<_i25.GetCompetitionsUsecase>()));
  gh.lazySingleton<_i48.StatisticsController>(() => _i48.StatisticsController(
      get<_i44.PersonUseCase>(),
      get<_i42.HabitUseCase>(),
      get<_i28.GetHabitsUsecase>()));
  gh.lazySingleton<_i49.AddFriendController>(() => _i49.AddFriendController(
      get<_i45.SearchEmailUsecase>(),
      get<_i23.FriendRequestUsecase>(),
      get<_i19.CancelFriendRequestUsecase>(),
      get<_i17.AcceptRequestUsecase>()));
  gh.lazySingleton<_i50.AddHabitController>(
      () => _i50.AddHabitController(get<_i42.HabitUseCase>()));
  gh.lazySingleton<_i51.CompetitionController>(() => _i51.CompetitionController(
      get<_i28.GetHabitsUsecase>(),
      get<_i32.GetRankingFriendsUsecase>(),
      get<_i41.GetUserDataUsecase>(),
      get<_i25.GetCompetitionsUsecase>(),
      get<_i24.GetCompetitionUsecase>(),
      get<_i34.MaxCompetitionsUsecase>(),
      get<_i30.SharedPref>(),
      get<_i13.RemoveCompetitorUsecase>(),
      get<_i26.GetFriendsUsecase>()));
  gh.factory<_i52.CompetitionUseCase>(
      () => _i52.CompetitionUseCase(
          get<_i14.Memory>(),
          get<_i44.PersonUseCase>(),
          get<_i6.IFireDatabase>(),
          get<_i8.IFireFunctions>(),
          get<_i25.GetCompetitionsUsecase>(),
          get<_i24.GetCompetitionUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i53.CompleteHabitUsecase>(
      () => _i53.CompleteHabitUsecase(
          get<_i14.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i44.PersonUseCase>(),
          get<_i46.SendCompetitionNotificationUsecase>(),
          get<_i27.GetHabitUsecase>(),
          get<_i25.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i54.EditHabitController>(
      () => _i54.EditHabitController(get<_i42.HabitUseCase>()));
  gh.lazySingleton<_i55.FriendsController>(() => _i55.FriendsController(
      get<_i26.GetFriendsUsecase>(),
      get<_i41.GetUserDataUsecase>(),
      get<_i15.RemoveFriendUsecase>(),
      get<_i30.SharedPref>()));
  gh.lazySingleton<_i56.HabitDetailsController>(() =>
      _i56.HabitDetailsController(
          get<_i42.HabitUseCase>(),
          get<_i52.CompetitionUseCase>(),
          get<_i53.CompleteHabitUsecase>(),
          get<_i27.GetHabitUsecase>()));
  gh.lazySingleton<_i57.HomeController>(() => _i57.HomeController(
      get<_i28.GetHabitsUsecase>(),
      get<_i53.CompleteHabitUsecase>(),
      get<_i35.MaxHabitsUsecase>(),
      get<_i18.IFireAnalytics>(),
      get<_i58.AppLogic>(),
      get<_i44.PersonUseCase>(),
      get<_i52.CompetitionUseCase>(),
      get<_i41.GetUserDataUsecase>()));
  gh.lazySingleton<_i59.EditAlarmController>(() => _i59.EditAlarmController(
      get<_i56.HabitDetailsController>(),
      get<_i42.HabitUseCase>(),
      get<_i18.IFireAnalytics>()));
  gh.lazySingleton<_i60.EditCueController>(() => _i60.EditCueController(
      get<_i42.HabitUseCase>(),
      get<_i18.IFireAnalytics>(),
      get<_i56.HabitDetailsController>()));
  gh.singleton<_i58.AppLogic>(_i58.AppLogic());
  gh.singleton<_i18.IFireAnalytics>(_i61.FireAnalytics(),
      registerFor: {_service});
  gh.singletonAsync<_i43.ILocalNotification>(
      () => _i62.LocalNotification.initialize(),
      registerFor: {_service});
  gh.singleton<_i14.Memory>(_i14.Memory());
  gh.singletonAsync<_i30.SharedPref>(() => _i30.SharedPref.initialize(),
      registerFor: {_service});
  return get;
}
