import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/feature/setting/domain/usecases/create_person_usecase.dart';
import 'package:altitude/feature/setting/domain/usecases/logout_usecase.dart';
import 'package:altitude/feature/setting/domain/usecases/recalculate_score_usecasse.dart';
import 'package:altitude/feature/setting/domain/usecases/transfer_habit_usecase.dart';
import 'package:altitude/feature/setting/domain/usecases/update_name_usecase.dart';
import 'package:altitude/feature/setting/domain/usecases/update_total_score_usecase.dart';
import 'package:altitude/feature/setting/presentation/controllers/settings_controller.dart';

void setupSettings() {
  // USECASES
  serviceLocator.registerFactory(() => CreatePersonUsecase(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ));

  serviceLocator.registerFactory(() => LogoutUsecase(
        serviceLocator.get(),
        serviceLocator.get(),
      ));

  serviceLocator.registerFactory(() => RecalculateScoreUsecase(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ));

  serviceLocator.registerFactory(() => TransferHabitUsecase(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ));

  serviceLocator.registerFactory(() => UpdateNameUsecase(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ));

  serviceLocator.registerFactory(() => UpdateTotalScoreUsecase(
        serviceLocator.get(),
        serviceLocator.get(),
      ));

  // CONTROLLERS
  serviceLocator.registerLazySingleton(() => SettingsController(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ));
}
