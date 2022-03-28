import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/common/infra/interface/i_score_service.dart';
import 'package:altitude/common/infra/services/score_service.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/core/services/FireAuth.dart';
import 'package:altitude/core/services/FireDatabase.dart';
import 'package:altitude/core/services/FireFunctions.dart';
import 'package:altitude/core/services/FireMenssaging.dart';
import 'package:altitude/core/services/LocalNotification.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_fire_functions.dart';
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart';
import 'package:altitude/core/services/interfaces/i_local_notification.dart';

void setupInfra() {
  serviceLocator.registerFactory<IScoreService>(() => ScoreService());

  serviceLocator.registerSingleton<IFireAnalytics>(FireAnalytics());

  serviceLocator.registerSingleton<Memory>(Memory());

  serviceLocator.registerSingletonAsync<ILocalNotification>(
      () => LocalNotification.initialize());

  serviceLocator.registerFactory<IFireMessaging>(() => FireMessaging());

  serviceLocator.registerFactory<IFireFunctions>(() => FireFunctions());

  serviceLocator.registerFactory<IFireDatabase>(() => FireDatabase());

  serviceLocator.registerFactory<IFireAuth>(() => FireAuth());
}
