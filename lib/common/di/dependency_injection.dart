import 'package:altitude/common/di/dependency_injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

GetIt serviceLocator = GetIt.I;

@InjectableInit(initializerName: r'$initGetIt')
Future<GetIt> configureDependencies() => $initGetIt(serviceLocator);
