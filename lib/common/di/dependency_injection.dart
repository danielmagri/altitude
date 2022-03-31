import 'package:altitude/common/di/dependency_injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

GetIt serviceLocator = GetIt.instance;

@InjectableInit(initializerName: r'$initGetIt')
void configureDependencies() => $initGetIt(serviceLocator);
