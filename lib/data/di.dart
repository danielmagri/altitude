import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:altitude/data/repository/notifications_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:altitude/common/di/dependency_injection.dart';

void setupData() {
  serviceLocator.registerFactory<INotificationsRepository>(
      () => NotificationsRepository(serviceLocator.get()));

  serviceLocator.registerFactory<IHabitsRepository>(() => HabitsRepository(
      serviceLocator.get(), serviceLocator.get(), serviceLocator.get()));

  serviceLocator.registerFactory<IUserRepository>(() => UserRepository(
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get()));

  serviceLocator.registerFactory<ICompetitionsRepository>(
      () => CompetitionsRepository(serviceLocator.get(), serviceLocator.get()));
}
