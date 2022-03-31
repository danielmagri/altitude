import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/presentation/competitions/controllers/competition_controller.dart';
import 'package:altitude/presentation/competitions/controllers/competition_details_controller.dart';
import 'package:altitude/presentation/competitions/controllers/create_competition_controller.dart';
import 'package:altitude/presentation/competitions/controllers/pending_competition_controller.dart';

void setupCompetitions() {
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
