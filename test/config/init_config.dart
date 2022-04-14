import 'package:altitude/core/di/get_it_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'init_config.config.dart';

final getIt = GetIt.instance;

const serviceTest = Environment("service_test");
const usecaseTest = Environment("usecase_test");

void initConfig({bool mockUseCase = false}) {
  TestWidgetsFlutterBinding.ensureInitialized();
  GetIt.I.resetScope();
  GetIt.I.allowReassignment = true;
  configureDependenciesTest(mockUseCase);
}

@InjectableInit(generateForDir: const ['lib', 'test'], initializerName: r'$initGetItTest')
void configureDependenciesTest(bool mockUseCase) {
  Set<String> env = Set();
  env.add(serviceTest.name);
  if (mockUseCase)
    env.add(usecaseTest.name);
  else
    env.add(usecase.name);

  $initGetItTest(getIt, environmentFilter: NoEnvOrContainsAny(env));
}
