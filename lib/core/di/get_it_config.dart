import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'get_it_config.config.dart';

final getIt = GetIt.instance;

const service = Environment("service");
const usecase = Environment("usecase");

@InjectableInit()
void configureDependencies() =>
    $initGetIt(getIt, environmentFilter: NoEnvOrContainsAny(Set.of([service.name, usecase.name])));
