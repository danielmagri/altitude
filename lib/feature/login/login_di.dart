import 'package:altitude/feature/login/logic/LoginLogic.dart';
import 'package:get_it/get_it.dart';

abstract class LoginDI {
  static void setup() {
    GetIt.I.registerLazySingleton<LoginLogic>(() => LoginLogic());
  }
}
