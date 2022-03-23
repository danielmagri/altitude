// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:altitude/common/app_logic.dart' as _i55;
import 'package:altitude/common/domain/usecases/competitions/get_competition_usecase.dart'
    as _i31;
import 'package:altitude/common/domain/usecases/competitions/get_competitions_usecase.dart'
    as _i32;
import 'package:altitude/common/domain/usecases/friends/get_friends_usecase.dart'
    as _i33;
import 'package:altitude/common/domain/usecases/habits/complete_habit_usecase.dart'
    as _i50;
import 'package:altitude/common/domain/usecases/habits/get_habit_usecase.dart'
    as _i34;
import 'package:altitude/common/domain/usecases/habits/get_habits_usecase.dart'
    as _i35;
import 'package:altitude/common/domain/usecases/habits/max_habits_usecase.dart'
    as _i42;
import 'package:altitude/common/domain/usecases/notifications/send_competition_notification_usecase.dart'
    as _i18;
import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart'
    as _i52;
import 'package:altitude/common/domain/usecases/user/update_fcm_token_usecase.dart'
    as _i47;
import 'package:altitude/common/shared_pref/shared_pref.dart' as _i37;
import 'package:altitude/common/useCase/CompetitionUseCase.dart' as _i49;
import 'package:altitude/common/useCase/HabitUseCase.dart' as _i24;
import 'package:altitude/common/useCase/PersonUseCase.dart' as _i19;
import 'package:altitude/core/services/FireAnalytics.dart' as _i63;
import 'package:altitude/core/services/FireAuth.dart' as _i5;
import 'package:altitude/core/services/FireDatabase.dart' as _i7;
import 'package:altitude/core/services/FireFunctions.dart' as _i9;
import 'package:altitude/core/services/FireMenssaging.dart' as _i11;
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart'
    as _i22;
import 'package:altitude/core/services/interfaces/i_fire_auth.dart' as _i4;
import 'package:altitude/core/services/interfaces/i_fire_database.dart' as _i6;
import 'package:altitude/core/services/interfaces/i_fire_functions.dart' as _i8;
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart'
    as _i10;
import 'package:altitude/core/services/interfaces/i_local_notification.dart'
    as _i12;
import 'package:altitude/core/services/LocalNotification.dart' as _i64;
import 'package:altitude/core/services/Memory.dart' as _i16;
import 'package:altitude/feature/competitions/domain/usecases/create_competition_usecase.dart'
    as _i26;
import 'package:altitude/feature/competitions/domain/usecases/decline_competition_request_usecase.dart'
    as _i27;
import 'package:altitude/feature/competitions/domain/usecases/get_pending_competitions_usecase.dart'
    as _i36;
import 'package:altitude/feature/competitions/domain/usecases/get_ranking_friends_usecase.dart'
    as _i39;
import 'package:altitude/feature/competitions/domain/usecases/max_competitions_by_habit_usecase.dart'
    as _i40;
import 'package:altitude/feature/competitions/domain/usecases/max_competitions_usecase.dart'
    as _i41;
import 'package:altitude/feature/competitions/domain/usecases/remove_competitor_usecase.dart'
    as _i15;
import 'package:altitude/feature/competitions/domain/usecases/update_competition_usecase.dart'
    as _i20;
import 'package:altitude/feature/competitions/presentation/controllers/competition_controller.dart'
    as _i58;
import 'package:altitude/feature/competitions/presentation/controllers/competition_details_controller.dart'
    as _i48;
import 'package:altitude/feature/competitions/presentation/controllers/create_competition_controller.dart'
    as _i51;
import 'package:altitude/feature/competitions/presentation/controllers/pending_competition_controller.dart'
    as _i43;
import 'package:altitude/feature/friends/domain/usecases/accept_request_usecase.dart'
    as _i21;
import 'package:altitude/feature/friends/domain/usecases/cancel_friend_request_usecase.dart'
    as _i25;
import 'package:altitude/feature/friends/domain/usecases/decline_request_usecase.dart'
    as _i28;
import 'package:altitude/feature/friends/domain/usecases/friend_request_usecase.dart'
    as _i30;
import 'package:altitude/feature/friends/domain/usecases/get_pending_friends_usecase.dart'
    as _i38;
import 'package:altitude/feature/friends/domain/usecases/remove_friend_usecase.dart'
    as _i17;
import 'package:altitude/feature/friends/domain/usecases/search_email_usecase.dart'
    as _i56;
import 'package:altitude/feature/friends/presentation/controllers/add_friend_controller.dart'
    as _i57;
import 'package:altitude/feature/friends/presentation/controllers/friends_controller.dart'
    as _i61;
import 'package:altitude/feature/friends/presentation/controllers/pending_friends_controller.dart'
    as _i44;
import 'package:altitude/feature/habits/presentation/controllers/add_habit_controller.dart'
    as _i23;
import 'package:altitude/feature/habits/presentation/controllers/edit_alarm_controller.dart'
    as _i59;
import 'package:altitude/feature/habits/presentation/controllers/edit_cue_controller.dart'
    as _i60;
import 'package:altitude/feature/habits/presentation/controllers/edit_habit_controller.dart'
    as _i29;
import 'package:altitude/feature/habits/presentation/controllers/habit_details_controller.dart'
    as _i53;
import 'package:altitude/feature/home/presentation/controllers/home_controller.dart'
    as _i54;
import 'package:altitude/feature/login/domain/usecases/auth_google_usecase.dart'
    as _i3;
import 'package:altitude/feature/login/presentation/controllers/login_controller.dart'
    as _i14;
import 'package:altitude/feature/setting/presentation/controllers/settings_controller.dart'
    as _i45;
import 'package:altitude/feature/statistics/presentation/controllers/statistics_controller.dart'
    as _i46;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'mocks/services_mocks.dart' as _i13;
import 'mocks/shared_pref_mock.dart' as _i65;
import 'mocks/use_case_mocks.dart' as _i62;

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
  gh.factory<_i17.RemoveFriendUsecase>(
      () => _i17.RemoveFriendUsecase(
          get<_i6.IFireDatabase>(), get<_i4.IFireAuth>()),
      registerFor: {_usecase});
  gh.factory<_i18.SendCompetitionNotificationUsecase>(
      () => _i18.SendCompetitionNotificationUsecase(
          get<_i19.PersonUseCase>(), get<_i8.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i20.UpdateCompetitionUsecase>(
      () => _i20.UpdateCompetitionUsecase(
          get<_i6.IFireDatabase>(), get<_i16.Memory>()),
      registerFor: {_usecase});
  gh.factory<_i21.AcceptRequestUsecase>(
      () => _i21.AcceptRequestUsecase(
          get<_i6.IFireDatabase>(),
          get<_i4.IFireAuth>(),
          get<_i22.IFireAnalytics>(),
          get<_i16.Memory>(),
          get<_i8.IFireFunctions>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i23.AddHabitController>(
      () => _i23.AddHabitController(get<_i24.HabitUseCase>()));
  gh.factory<_i25.CancelFriendRequestUsecase>(
      () => _i25.CancelFriendRequestUsecase(get<_i6.IFireDatabase>(),
          get<_i4.IFireAuth>(), get<_i22.IFireAnalytics>(), get<_i16.Memory>()),
      registerFor: {_usecase});
  gh.factory<_i26.CreateCompetitionUsecase>(
      () => _i26.CreateCompetitionUsecase(
          get<_i6.IFireDatabase>(),
          get<_i10.IFireMessaging>(),
          get<_i8.IFireFunctions>(),
          get<_i22.IFireAnalytics>(),
          get<_i4.IFireAuth>(),
          get<_i16.Memory>()),
      registerFor: {_usecase});
  gh.factory<_i27.DeclineCompetitionRequestUsecase>(
      () => _i27.DeclineCompetitionRequestUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i28.DeclineRequestUsecase>(
      () => _i28.DeclineRequestUsecase(get<_i6.IFireDatabase>(),
          get<_i4.IFireAuth>(), get<_i22.IFireAnalytics>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i29.EditHabitController>(
      () => _i29.EditHabitController(get<_i24.HabitUseCase>()));
  gh.factory<_i30.FriendRequestUsecase>(
      () => _i30.FriendRequestUsecase(
          get<_i6.IFireDatabase>(),
          get<_i4.IFireAuth>(),
          get<_i22.IFireAnalytics>(),
          get<_i16.Memory>(),
          get<_i8.IFireFunctions>()),
      registerFor: {_usecase});
  gh.factory<_i31.GetCompetitionUsecase>(
      () => _i31.GetCompetitionUsecase(
          get<_i16.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i32.GetCompetitionsUsecase>(
      () => _i32.GetCompetitionsUsecase(
          get<_i16.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i33.GetFriendsUsecase>(
      () => _i33.GetFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i34.GetHabitUsecase>(
      () => _i34.GetHabitUsecase(get<_i16.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i35.GetHabitsUsecase>(
      () => _i35.GetHabitsUsecase(get<_i16.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i36.GetPendingCompetitionsUsecase>(
      () => _i36.GetPendingCompetitionsUsecase(
          get<_i6.IFireDatabase>(), get<_i37.SharedPref>()),
      registerFor: {_usecase});
  gh.factory<_i38.GetPendingFriendsUsecase>(
      () => _i38.GetPendingFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i39.GetRankingFriendsUsecase>(
      () => _i39.GetRankingFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i40.MaxCompetitionsByHabitUsecase>(
      () => _i40.MaxCompetitionsByHabitUsecase(
          get<_i32.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i41.MaxCompetitionsUsecase>(
      () => _i41.MaxCompetitionsUsecase(get<_i32.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i42.MaxHabitsUsecase>(
      () => _i42.MaxHabitsUsecase(get<_i35.GetHabitsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i43.PendingCompetitionController>(() =>
      _i43.PendingCompetitionController(
          get<_i41.MaxCompetitionsUsecase>(),
          get<_i35.GetHabitsUsecase>(),
          get<_i37.SharedPref>(),
          get<_i36.GetPendingCompetitionsUsecase>(),
          get<_i27.DeclineCompetitionRequestUsecase>()));
  gh.lazySingleton<_i44.PendingFriendsController>(() =>
      _i44.PendingFriendsController(
          get<_i38.GetPendingFriendsUsecase>(),
          get<_i21.AcceptRequestUsecase>(),
          get<_i28.DeclineRequestUsecase>(),
          get<_i37.SharedPref>()));
  gh.lazySingleton<_i45.SettingsController>(() => _i45.SettingsController(
      get<_i19.PersonUseCase>(),
      get<_i24.HabitUseCase>(),
      get<_i37.SharedPref>(),
      get<_i32.GetCompetitionsUsecase>()));
  gh.lazySingleton<_i46.StatisticsController>(() => _i46.StatisticsController(
      get<_i19.PersonUseCase>(),
      get<_i24.HabitUseCase>(),
      get<_i35.GetHabitsUsecase>()));
  gh.factory<_i47.UpdateFCMTokenUsecase>(
      () => _i47.UpdateFCMTokenUsecase(
          get<_i10.IFireMessaging>(),
          get<_i6.IFireDatabase>(),
          get<_i16.Memory>(),
          get<_i32.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i48.CompetitionDetailsController>(() =>
      _i48.CompetitionDetailsController(
          get<_i33.GetFriendsUsecase>(),
          get<_i15.RemoveCompetitorUsecase>(),
          get<_i20.UpdateCompetitionUsecase>()));
  gh.factory<_i49.CompetitionUseCase>(
      () => _i49.CompetitionUseCase(
          get<_i16.Memory>(),
          get<_i19.PersonUseCase>(),
          get<_i6.IFireDatabase>(),
          get<_i8.IFireFunctions>(),
          get<_i32.GetCompetitionsUsecase>(),
          get<_i31.GetCompetitionUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i50.CompleteHabitUsecase>(
      () => _i50.CompleteHabitUsecase(
          get<_i16.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i19.PersonUseCase>(),
          get<_i18.SendCompetitionNotificationUsecase>(),
          get<_i34.GetHabitUsecase>(),
          get<_i32.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i51.CreateCompetitionController>(() =>
      _i51.CreateCompetitionController(get<_i26.CreateCompetitionUsecase>(),
          get<_i40.MaxCompetitionsByHabitUsecase>()));
  gh.factory<_i52.GetUserDataUsecase>(
      () => _i52.GetUserDataUsecase(
          get<_i16.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i4.IFireAuth>(),
          get<_i10.IFireMessaging>(),
          get<_i47.UpdateFCMTokenUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i53.HabitDetailsController>(() =>
      _i53.HabitDetailsController(
          get<_i24.HabitUseCase>(),
          get<_i49.CompetitionUseCase>(),
          get<_i50.CompleteHabitUsecase>(),
          get<_i34.GetHabitUsecase>()));
  gh.factory<_i24.HabitUseCase>(
      () => _i24.HabitUseCase(
          get<_i16.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i12.ILocalNotification>(),
          get<_i22.IFireAnalytics>(),
          get<_i52.GetUserDataUsecase>(),
          get<_i32.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i54.HomeController>(() => _i54.HomeController(
      get<_i35.GetHabitsUsecase>(),
      get<_i50.CompleteHabitUsecase>(),
      get<_i42.MaxHabitsUsecase>(),
      get<_i22.IFireAnalytics>(),
      get<_i55.AppLogic>(),
      get<_i19.PersonUseCase>(),
      get<_i49.CompetitionUseCase>(),
      get<_i52.GetUserDataUsecase>()));
  gh.factory<_i19.PersonUseCase>(
      () => _i19.PersonUseCase(
          get<_i16.Memory>(),
          get<_i4.IFireAuth>(),
          get<_i10.IFireMessaging>(),
          get<_i6.IFireDatabase>(),
          get<_i52.GetUserDataUsecase>(),
          get<_i47.UpdateFCMTokenUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i56.SearchEmailUsecase>(
      () => _i56.SearchEmailUsecase(get<_i6.IFireDatabase>(),
          get<_i52.GetUserDataUsecase>(), get<_i4.IFireAuth>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i57.AddFriendController>(() => _i57.AddFriendController(
      get<_i56.SearchEmailUsecase>(),
      get<_i30.FriendRequestUsecase>(),
      get<_i25.CancelFriendRequestUsecase>(),
      get<_i21.AcceptRequestUsecase>()));
  gh.lazySingleton<_i58.CompetitionController>(() => _i58.CompetitionController(
      get<_i35.GetHabitsUsecase>(),
      get<_i39.GetRankingFriendsUsecase>(),
      get<_i52.GetUserDataUsecase>(),
      get<_i32.GetCompetitionsUsecase>(),
      get<_i31.GetCompetitionUsecase>(),
      get<_i41.MaxCompetitionsUsecase>(),
      get<_i37.SharedPref>(),
      get<_i15.RemoveCompetitorUsecase>(),
      get<_i33.GetFriendsUsecase>()));
  gh.lazySingleton<_i59.EditAlarmController>(() => _i59.EditAlarmController(
      get<_i53.HabitDetailsController>(),
      get<_i24.HabitUseCase>(),
      get<_i22.IFireAnalytics>()));
  gh.lazySingleton<_i60.EditCueController>(() => _i60.EditCueController(
      get<_i24.HabitUseCase>(),
      get<_i22.IFireAnalytics>(),
      get<_i53.HabitDetailsController>()));
  gh.lazySingleton<_i61.FriendsController>(() => _i61.FriendsController(
      get<_i33.GetFriendsUsecase>(),
      get<_i52.GetUserDataUsecase>(),
      get<_i17.RemoveFriendUsecase>(),
      get<_i37.SharedPref>()));
  gh.singleton<_i55.AppLogic>(_i55.AppLogic());
  gh.singleton<_i49.CompetitionUseCase>(_i62.MockCompetitionUseCase(),
      registerFor: {_usecase_test});
  gh.singleton<_i24.HabitUseCase>(_i62.MockHabitUseCase(),
      registerFor: {_usecase_test});
  gh.singleton<_i22.IFireAnalytics>(_i13.MockFireAnalytics(),
      registerFor: {_service_test});
  gh.singleton<_i22.IFireAnalytics>(_i63.FireAnalytics(),
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
      () => _i64.LocalNotification.initialize(),
      registerFor: {_service});
  gh.singleton<_i16.Memory>(_i16.Memory());
  gh.singleton<_i65.MockSharedPref>(_i65.MockSharedPref(),
      registerFor: {_service_test});
  gh.singleton<_i19.PersonUseCase>(_i62.MockPersonUseCase(),
      registerFor: {_usecase_test});
  gh.singletonAsync<_i37.SharedPref>(() => _i37.SharedPref.initialize(),
      registerFor: {_service});
  return get;
}
