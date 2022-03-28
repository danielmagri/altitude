import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/common/domain/usecases/competitions/get_competition_usecase.dart';
import 'package:altitude/common/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/common/domain/usecases/friends/get_friends_usecase.dart';
import 'package:altitude/common/domain/usecases/habits/complete_habit_usecase.dart';
import 'package:altitude/common/domain/usecases/habits/get_habit_usecase.dart';
import 'package:altitude/common/domain/usecases/habits/get_habits_usecase.dart';
import 'package:altitude/common/domain/usecases/habits/get_reminder_counter_usecase.dart';
import 'package:altitude/common/domain/usecases/habits/max_habits_usecase.dart';
import 'package:altitude/common/domain/usecases/notifications/send_competition_notification_usecase.dart';
import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/common/domain/usecases/user/is_logged_usecase.dart';
import 'package:altitude/common/domain/usecases/user/update_fcm_token_usecase.dart';

void setupDomain() {
  serviceLocator.registerFactory(
      () => GetCompetitionUsecase(serviceLocator.get(), serviceLocator.get()));

  serviceLocator.registerFactory(
      () => GetCompetitionsUsecase(serviceLocator.get(), serviceLocator.get()));

  serviceLocator.registerFactory(() => GetFriendsUsecase(serviceLocator.get()));

  serviceLocator.registerFactory(() => SendCompetitionNotificationUsecase(
      serviceLocator.get(), serviceLocator.get()));

  serviceLocator.registerFactory(() => MaxHabitsUsecase(serviceLocator.get()));

  serviceLocator.registerFactory(() =>
      GetReminderCounterUsecase(serviceLocator.get(), serviceLocator.get()));

  serviceLocator.registerFactory(
      () => GetHabitsUsecase(serviceLocator.get(), serviceLocator.get()));

  serviceLocator.registerFactory(
      () => GetHabitUsecase(serviceLocator.get(), serviceLocator.get()));

  serviceLocator.registerFactory(() => CompleteHabitUsecase(
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get()));

  serviceLocator.registerFactory(() => UpdateFCMTokenUsecase(
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get()));

  serviceLocator.registerFactory(() => IsLoggedUsecase(serviceLocator.get()));

  serviceLocator.registerFactory(() => GetUserDataUsecase(
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get()));
}
