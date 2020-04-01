import 'package:altitude/feature/home/logic/HomeLogic.dart';
import 'package:get_it/get_it.dart';

class Getit {
  static init() {
    var getIt = GetIt.instance;

    getIt.registerLazySingleton<HomeLogic>(() => HomeLogic());
  }
}