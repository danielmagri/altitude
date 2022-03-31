import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/domain/usecases/competitions/get_competition_usecase.dart';
import 'package:altitude/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/domain/usecases/friends/get_friends_usecase.dart';
import 'package:altitude/domain/usecases/habits/complete_habit_usecase.dart';
import 'package:altitude/domain/usecases/habits/get_habit_usecase.dart';
import 'package:altitude/domain/usecases/habits/get_habits_usecase.dart';
import 'package:altitude/domain/usecases/habits/get_reminder_counter_usecase.dart';
import 'package:altitude/domain/usecases/habits/max_habits_usecase.dart';
import 'package:altitude/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/domain/usecases/user/is_logged_usecase.dart';
import 'package:altitude/domain/usecases/user/update_fcm_token_usecase.dart';

void setupAllDomain() {
  serviceLocator
      .registerFactory(() => GetCompetitionUsecase(serviceLocator.get()));

  serviceLocator
      .registerFactory(() => GetCompetitionsUsecase(serviceLocator.get()));

  serviceLocator.registerFactory(() => GetFriendsUsecase(serviceLocator.get()));

  serviceLocator.registerFactory(() => MaxHabitsUsecase(serviceLocator.get()));

  serviceLocator
      .registerFactory(() => GetReminderCounterUsecase(serviceLocator.get()));

  serviceLocator.registerFactory(() => GetHabitsUsecase(serviceLocator.get()));

  serviceLocator.registerFactory(() => GetHabitUsecase(serviceLocator.get()));

  serviceLocator.registerFactory(() => CompleteHabitUsecase(
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get()));

  serviceLocator
      .registerFactory(() => UpdateFCMTokenUsecase(serviceLocator.get()));

  serviceLocator.registerFactory(() => IsLoggedUsecase(serviceLocator.get()));

  serviceLocator
      .registerFactory(() => GetUserDataUsecase(serviceLocator.get()));

      serviceLocator.registerFactory(() => AcceptCompetitionRequestUsecase(
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get()));

  serviceLocator.registerFactory(() => CreateCompetitionUsecase(
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get()));

  serviceLocator.registerFactory(
      () => DeclineCompetitionRequestUsecase(serviceLocator.get()));

  serviceLocator
      .registerFactory(() => GetDaysDoneUsecase(serviceLocator.get()));

  serviceLocator.registerFactory(() => GetPendingCompetitionsUsecase(
      serviceLocator.get(), serviceLocator.get()));

  serviceLocator.registerFactory(() =>
      UpdateCompetitionUsecase(serviceLocator.get(), serviceLocator.get()));

  serviceLocator.registerFactory(() => RemoveCompetitorUsecase(
      serviceLocator.get(), serviceLocator.get(), serviceLocator.get()));

  serviceLocator
      .registerFactory(() => MaxCompetitionsUsecase(serviceLocator.get()));

  serviceLocator.registerFactory(
      () => MaxCompetitionsByHabitUsecase(serviceLocator.get()));

  serviceLocator.registerFactory(() => InviteCompetitorUsecase(
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get()));

  serviceLocator
      .registerFactory(() => GetRankingFriendsUsecase(serviceLocator.get()));
}
