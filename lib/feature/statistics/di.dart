import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/feature/statistics/domain/usecases/get_all_days_done_usecase.dart';
import 'package:altitude/feature/statistics/presentation/controllers/statistics_controller.dart';

void setupStatistics() {
  // USECASES
  serviceLocator.registerFactory(() => GetAllDaysDoneUsecase(
        serviceLocator.get(),
      ));

  // CONTROLLERS
  serviceLocator.registerLazySingleton(() => StatisticsController(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ));
}
