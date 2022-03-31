import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/presentation/home/domain/usecases/update_level_usecase.dart';
import 'package:altitude/presentation/home/presentation/controllers/home_controller.dart';

void setupHome() {
  // USECASES
  serviceLocator.registerFactory(() => UpdateLevelUsecase(
        serviceLocator.get(),
        serviceLocator.get(),
      ));

  // CONTROLLERS
  serviceLocator.registerLazySingleton(() => HomeController(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ));
}
