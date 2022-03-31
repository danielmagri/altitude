import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/presentation/login/domain/usecases/auth_google_usecase.dart';
import 'package:altitude/presentation/login/presentation/controllers/login_controller.dart';

void setupLogin() {
  // USECASES
  serviceLocator.registerFactory(() => AuthGoogleUsecase());

  // CONTROLLERS
  serviceLocator.registerLazySingleton(() => LoginController(
        serviceLocator.get(),
      ));
}
