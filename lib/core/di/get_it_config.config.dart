// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../common/app_logic.dart' as _i50;
import '../../common/domain/usecases/competitions/get_competition_usecase.dart'
    as _i19;
import '../../common/domain/usecases/competitions/get_competitions_usecase.dart'
    as _i20;
import '../../common/domain/usecases/friends/get_friends_usecase.dart' as _i21;
import '../../common/domain/usecases/habits/complete_habit_usecase.dart'
    as _i45;
import '../../common/domain/usecases/habits/get_habit_usecase.dart' as _i22;
import '../../common/domain/usecases/habits/get_habits_usecase.dart' as _i23;
import '../../common/domain/usecases/habits/max_habits_usecase.dart' as _i29;
import '../../common/domain/usecases/notifications/send_competition_notification_usecase.dart'
    as _i38;
import '../../common/domain/usecases/user/get_user_data_usecase.dart' as _i34;
import '../../common/domain/usecases/user/update_fcm_token_usecase.dart'
    as _i31;
import '../../common/shared_pref/shared_pref.dart' as _i25;
import '../../common/useCase/CompetitionUseCase.dart' as _i44;
import '../../common/useCase/HabitUseCase.dart' as _i35;
import '../../common/useCase/PersonUseCase.dart' as _i37;
import '../../feature/competitions/domain/usecases/create_competition_usecase.dart'
    as _i16;
import '../../feature/competitions/domain/usecases/decline_competition_request_usecase.dart'
    as _i18;
import '../../feature/competitions/domain/usecases/get_pending_competitions_usecase.dart'
    as _i24;
import '../../feature/competitions/domain/usecases/get_ranking_friends_usecase.dart'
    as _i26;
import '../../feature/competitions/domain/usecases/max_competitions_by_habit_usecase.dart'
    as _i27;
import '../../feature/competitions/domain/usecases/max_competitions_usecase.dart'
    as _i28;
import '../../feature/competitions/domain/usecases/remove_competitor_usecase.dart'
    as _i13;
import '../../feature/competitions/domain/usecases/update_competition_usecase.dart'
    as _i15;
import '../../feature/competitions/presentation/controllers/competition_controller.dart'
    as _i43;
import '../../feature/competitions/presentation/controllers/competition_details_controller.dart'
    as _i32;
import '../../feature/competitions/presentation/controllers/create_competition_controller.dart'
    as _i33;
import '../../feature/competitions/presentation/controllers/pending_competition_controller.dart'
    as _i30;
import '../../feature/friends/presentation/controllers/add_friend_controller.dart'
    as _i41;
import '../../feature/friends/presentation/controllers/friends_controller.dart'
    as _i47;
import '../../feature/friends/presentation/controllers/pending_friends_controller.dart'
    as _i51;
import '../../feature/habits/presentation/controllers/add_habit_controller.dart'
    as _i42;
import '../../feature/habits/presentation/controllers/edit_alarm_controller.dart'
    as _i52;
import '../../feature/habits/presentation/controllers/edit_cue_controller.dart'
    as _i53;
import '../../feature/habits/presentation/controllers/edit_habit_controller.dart'
    as _i46;
import '../../feature/habits/presentation/controllers/habit_details_controller.dart'
    as _i48;
import '../../feature/home/presentation/controllers/home_controller.dart'
    as _i49;
import '../../feature/login/domain/usecases/auth_google_usecase.dart' as _i3;
import '../../feature/login/presentation/controllers/login_controller.dart'
    as _i12;
import '../../feature/setting/presentation/controllers/settings_controller.dart'
    as _i39;
import '../../feature/statistics/presentation/controllers/statistics_controller.dart'
    as _i40;
import '../services/FireAnalytics.dart' as _i54;
import '../services/FireAuth.dart' as _i5;
import '../services/FireDatabase.dart' as _i7;
import '../services/FireFunctions.dart' as _i9;
import '../services/FireMenssaging.dart' as _i11;
import '../services/interfaces/i_fire_analytics.dart' as _i17;
import '../services/interfaces/i_fire_auth.dart' as _i4;
import '../services/interfaces/i_fire_database.dart' as _i6;
import '../services/interfaces/i_fire_functions.dart' as _i8;
import '../services/interfaces/i_fire_messaging.dart' as _i10;
import '../services/interfaces/i_local_notification.dart' as _i36;
import '../services/LocalNotification.dart' as _i55;
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
  gh.factory<_i15.UpdateCompetitionUsecase>(
      () => _i15.UpdateCompetitionUsecase(
          get<_i6.IFireDatabase>(), get<_i14.Memory>()),
      registerFor: {_usecase});
  gh.factory<_i16.CreateCompetitionUsecase>(
      () => _i16.CreateCompetitionUsecase(
          get<_i6.IFireDatabase>(),
          get<_i10.IFireMessaging>(),
          get<_i8.IFireFunctions>(),
          get<_i17.IFireAnalytics>(),
          get<_i4.IFireAuth>(),
          get<_i14.Memory>()),
      registerFor: {_usecase});
  gh.factory<_i18.DeclineCompetitionRequestUsecase>(
      () => _i18.DeclineCompetitionRequestUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i19.GetCompetitionUsecase>(
      () => _i19.GetCompetitionUsecase(
          get<_i14.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i20.GetCompetitionsUsecase>(
      () => _i20.GetCompetitionsUsecase(
          get<_i14.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i21.GetFriendsUsecase>(
      () => _i21.GetFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i22.GetHabitUsecase>(
      () => _i22.GetHabitUsecase(get<_i14.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i23.GetHabitsUsecase>(
      () => _i23.GetHabitsUsecase(get<_i14.Memory>(), get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i24.GetPendingCompetitionsUsecase>(
      () => _i24.GetPendingCompetitionsUsecase(
          get<_i6.IFireDatabase>(), get<_i25.SharedPref>()),
      registerFor: {_usecase});
  gh.factory<_i26.GetRankingFriendsUsecase>(
      () => _i26.GetRankingFriendsUsecase(get<_i6.IFireDatabase>()),
      registerFor: {_usecase});
  gh.factory<_i27.MaxCompetitionsByHabitUsecase>(
      () => _i27.MaxCompetitionsByHabitUsecase(
          get<_i20.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i28.MaxCompetitionsUsecase>(
      () => _i28.MaxCompetitionsUsecase(get<_i20.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i29.MaxHabitsUsecase>(
      () => _i29.MaxHabitsUsecase(get<_i23.GetHabitsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i30.PendingCompetitionController>(() =>
      _i30.PendingCompetitionController(
          get<_i28.MaxCompetitionsUsecase>(),
          get<_i23.GetHabitsUsecase>(),
          get<_i25.SharedPref>(),
          get<_i24.GetPendingCompetitionsUsecase>(),
          get<_i18.DeclineCompetitionRequestUsecase>()));
  gh.factory<_i31.UpdateFCMTokenUsecase>(
      () => _i31.UpdateFCMTokenUsecase(
          get<_i10.IFireMessaging>(),
          get<_i6.IFireDatabase>(),
          get<_i14.Memory>(),
          get<_i20.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i32.CompetitionDetailsController>(() =>
      _i32.CompetitionDetailsController(
          get<_i21.GetFriendsUsecase>(),
          get<_i13.RemoveCompetitorUsecase>(),
          get<_i15.UpdateCompetitionUsecase>()));
  gh.lazySingleton<_i33.CreateCompetitionController>(() =>
      _i33.CreateCompetitionController(get<_i16.CreateCompetitionUsecase>(),
          get<_i27.MaxCompetitionsByHabitUsecase>()));
  gh.factory<_i34.GetUserDataUsecase>(
      () => _i34.GetUserDataUsecase(
          get<_i14.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i4.IFireAuth>(),
          get<_i10.IFireMessaging>(),
          get<_i31.UpdateFCMTokenUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i35.HabitUseCase>(
      () => _i35.HabitUseCase(
          get<_i14.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i36.ILocalNotification>(),
          get<_i17.IFireAnalytics>(),
          get<_i34.GetUserDataUsecase>(),
          get<_i20.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i37.PersonUseCase>(
      () => _i37.PersonUseCase(
          get<_i14.Memory>(),
          get<_i4.IFireAuth>(),
          get<_i10.IFireMessaging>(),
          get<_i6.IFireDatabase>(),
          get<_i17.IFireAnalytics>(),
          get<_i8.IFireFunctions>(),
          get<_i34.GetUserDataUsecase>(),
          get<_i31.UpdateFCMTokenUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i38.SendCompetitionNotificationUsecase>(
      () => _i38.SendCompetitionNotificationUsecase(
          get<_i37.PersonUseCase>(), get<_i8.IFireFunctions>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i39.SettingsController>(() => _i39.SettingsController(
      get<_i37.PersonUseCase>(),
      get<_i35.HabitUseCase>(),
      get<_i25.SharedPref>(),
      get<_i20.GetCompetitionsUsecase>()));
  gh.lazySingleton<_i40.StatisticsController>(() => _i40.StatisticsController(
      get<_i37.PersonUseCase>(),
      get<_i35.HabitUseCase>(),
      get<_i23.GetHabitsUsecase>()));
  gh.lazySingleton<_i41.AddFriendController>(
      () => _i41.AddFriendController(get<_i37.PersonUseCase>()));
  gh.lazySingleton<_i42.AddHabitController>(
      () => _i42.AddHabitController(get<_i35.HabitUseCase>()));
  gh.lazySingleton<_i43.CompetitionController>(() => _i43.CompetitionController(
      get<_i23.GetHabitsUsecase>(),
      get<_i26.GetRankingFriendsUsecase>(),
      get<_i34.GetUserDataUsecase>(),
      get<_i20.GetCompetitionsUsecase>(),
      get<_i19.GetCompetitionUsecase>(),
      get<_i28.MaxCompetitionsUsecase>(),
      get<_i25.SharedPref>(),
      get<_i13.RemoveCompetitorUsecase>(),
      get<_i21.GetFriendsUsecase>()));
  gh.factory<_i44.CompetitionUseCase>(
      () => _i44.CompetitionUseCase(
          get<_i14.Memory>(),
          get<_i37.PersonUseCase>(),
          get<_i6.IFireDatabase>(),
          get<_i8.IFireFunctions>(),
          get<_i20.GetCompetitionsUsecase>(),
          get<_i19.GetCompetitionUsecase>()),
      registerFor: {_usecase});
  gh.factory<_i45.CompleteHabitUsecase>(
      () => _i45.CompleteHabitUsecase(
          get<_i14.Memory>(),
          get<_i6.IFireDatabase>(),
          get<_i37.PersonUseCase>(),
          get<_i38.SendCompetitionNotificationUsecase>(),
          get<_i22.GetHabitUsecase>(),
          get<_i20.GetCompetitionsUsecase>()),
      registerFor: {_usecase});
  gh.lazySingleton<_i46.EditHabitController>(
      () => _i46.EditHabitController(get<_i35.HabitUseCase>()));
  gh.lazySingleton<_i47.FriendsController>(() => _i47.FriendsController(
      get<_i37.PersonUseCase>(),
      get<_i21.GetFriendsUsecase>(),
      get<_i34.GetUserDataUsecase>()));
  gh.lazySingleton<_i48.HabitDetailsController>(() =>
      _i48.HabitDetailsController(
          get<_i35.HabitUseCase>(),
          get<_i44.CompetitionUseCase>(),
          get<_i45.CompleteHabitUsecase>(),
          get<_i22.GetHabitUsecase>()));
  gh.lazySingleton<_i49.HomeController>(() => _i49.HomeController(
      get<_i23.GetHabitsUsecase>(),
      get<_i45.CompleteHabitUsecase>(),
      get<_i29.MaxHabitsUsecase>(),
      get<_i17.IFireAnalytics>(),
      get<_i50.AppLogic>(),
      get<_i37.PersonUseCase>(),
      get<_i44.CompetitionUseCase>(),
      get<_i34.GetUserDataUsecase>()));
  gh.lazySingleton<_i51.PendingFriendsController>(
      () => _i51.PendingFriendsController(get<_i37.PersonUseCase>()));
  gh.lazySingleton<_i52.EditAlarmController>(() => _i52.EditAlarmController(
      get<_i48.HabitDetailsController>(),
      get<_i35.HabitUseCase>(),
      get<_i17.IFireAnalytics>()));
  gh.lazySingleton<_i53.EditCueController>(() => _i53.EditCueController(
      get<_i35.HabitUseCase>(),
      get<_i17.IFireAnalytics>(),
      get<_i48.HabitDetailsController>()));
  gh.singleton<_i50.AppLogic>(_i50.AppLogic());
  gh.singleton<_i17.IFireAnalytics>(_i54.FireAnalytics(),
      registerFor: {_service});
  gh.singletonAsync<_i36.ILocalNotification>(
      () => _i55.LocalNotification.initialize(),
      registerFor: {_service});
  gh.singleton<_i14.Memory>(_i14.Memory());
  gh.singletonAsync<_i25.SharedPref>(() => _i25.SharedPref.initialize(),
      registerFor: {_service});
  return get;
}
