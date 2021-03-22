import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_fire_functions.dart';
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart';
import 'package:altitude/core/services/interfaces/i_local_notification.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

import '../init_config.dart';

@serviceTest
@Singleton(as: IFireAnalytics)
class MockFireAnalytics extends Mock implements IFireAnalytics {}

@serviceTest
@Singleton(as: IFireAuth)
class MockFireAuth extends Mock implements IFireAuth {}

@serviceTest
@Singleton(as: IFireDatabase)
class MockFireDatabase extends Mock implements IFireDatabase {}

@serviceTest
@Singleton(as: IFireFunctions)
class MockFireFunctions extends Mock implements IFireFunctions {}

@serviceTest
@Singleton(as: IFireMessaging)
class MockFireMessaging extends Mock implements IFireMessaging {}

@serviceTest
@LazySingleton(as: ILocalNotification)
class MockLocalNotification extends Mock implements ILocalNotification {}
