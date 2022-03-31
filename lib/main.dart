import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/common/enums/theme_type.dart';
import 'package:altitude/common/router/Router.dart';
import 'package:altitude/common/shared_pref/shared_pref.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/presentation/home/pages/home_page.dart';
import 'package:altitude/presentation/login/pages/login_page.dart';
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
import 'package:altitude/presentation/tutorialPage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'common/app_logic.dart';
import 'common/theme/app_theme.dart';
import 'common/theme/dark_theme.dart';
import 'common/theme/light_theme.dart';
import 'core/services/interfaces/i_fire_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureDependencies();
  MobileAds.instance.initialize().then((status) {
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
          testDeviceIds: <String>["E5BCE9B277498E2110B5F4F43C1A0E6C"]),
    );
  });

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await GetIt.I.allReady();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  Widget initialPage() {
    if (!SharedPref.instance.habitTutorial &&
        !serviceLocator.get<IFireAuth>().isLogged()) {
      return TutorialPage();
    } else if (!serviceLocator.get<IFireAuth>().isLogged()) {
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
                    analytics: serviceLocator.get<IFireAnalytics>().analytics)
              ],
              onGenerateRoute: Router.generateRoute,
            ));
  }
}
