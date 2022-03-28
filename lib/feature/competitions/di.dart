import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/feature/competitions/domain/usecases/accept_competition_request_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/create_competition_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/decline_competition_request_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/get_days_done_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/get_pending_competitions_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/get_ranking_friends_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/invite_competitor_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/max_competitions_by_habit_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/max_competitions_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/remove_competitor_usecase.dart';
import 'package:altitude/feature/competitions/domain/usecases/update_competition_usecase.dart';
import 'package:altitude/feature/competitions/presentation/controllers/competition_controller.dart';
import 'package:altitude/feature/competitions/presentation/controllers/competition_details_controller.dart';
import 'package:altitude/feature/competitions/presentation/controllers/create_competition_controller.dart';
import 'package:altitude/feature/competitions/presentation/controllers/pending_competition_controller.dart';

void setupCompetitions() {
  // USECASES

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

  // CONTROLLERS

  serviceLocator.registerLazySingleton(() => PendingCompetitionController(
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get()));

  serviceLocator.registerLazySingleton(() =>
      CreateCompetitionController(serviceLocator.get(), serviceLocator.get()));

  serviceLocator.registerLazySingleton(() => CompetitionDetailsController(
      serviceLocator.get(), serviceLocator.get(), serviceLocator.get()));

  serviceLocator.registerLazySingleton(() => CompetitionController(
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get()));
}
