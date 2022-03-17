import 'package:altitude/common/enums/theme_type.dart';
import 'package:altitude/common/router/Router.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/feature/home/presentation/pages/home_page.dart';
import 'package:altitude/feature/login/presentation/pages/login_page.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart'
    show
        FlutterError,
        MaterialApp,
        StatelessWidget,
        Widget,
        WidgetsFlutterBinding,
        runApp;
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:altitude/feature/tutorialPage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'common/app_logic.dart';
import 'common/sharedPref/SharedPref.dart';
import 'common/theme/app_theme.dart';
import 'common/theme/dark_theme.dart';
import 'common/theme/light_theme.dart';
import 'core/di/get_it_config.dart';
import 'core/services/interfaces/i_fire_analytics.dart';
import 'core/services/interfaces/i_local_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureDependencies();
  MobileAds.instance.initialize().then((status) {
    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
          testDeviceIds: <String>["E5BCE9B277498E2110B5F4F43C1A0E6C"]),
    );
  });

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await GetIt.I.isReady<SharedPref>();
  await GetIt.I.isReady<ILocalNotification>();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  Widget initialPage() {
    if (!SharedPref.instance.habitTutorial &&
        !getIt.get<IFireAuth>().isLogged()) {
      return TutorialPage();
    } else if (!getIt.get<IFireAuth>().isLogged()) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }

  @override
  Widget build(context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return AppTheme(
        initialTheme: getThemeType(GetIt.I.get<SharedPref>().theme).toThemeMode,
        themeChanged: (theme) {
          GetIt.I
              .get<AppLogic>()
              .setDefaultStyle(theme.defaultSystemOverlayStyle);
        },
        builder: (mode) => MaterialApp(
              themeMode: mode,
              theme: LightTheme().materialTheme,
              darkTheme: DarkTheme().materialTheme,
              debugShowCheckedModeBanner: false,
              home: initialPage(),
              navigatorObservers: [
                FirebaseAnalyticsObserver(
                    analytics: getIt.get<IFireAnalytics>().analytics)
              ],
              onGenerateRoute: Router.generateRoute,
            ));
  }
}
