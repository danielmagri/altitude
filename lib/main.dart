import 'package:altitude/common/app_logic.dart';
import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/common/enums/theme_type.dart';
import 'package:altitude/common/router/Router.dart';
import 'package:altitude/common/theme/app_theme.dart';
import 'package:altitude/common/theme/dark_theme.dart';
import 'package:altitude/common/theme/light_theme.dart';
import 'package:altitude/infra/interface/i_fire_analytics.dart';
import 'package:altitude/infra/interface/i_fire_auth.dart';
import 'package:altitude/infra/services/shared_pref/shared_pref.dart';
import 'package:altitude/presentation/home/pages/home_page.dart';
import 'package:altitude/presentation/login/pages/login_page.dart';
import 'package:altitude/presentation/tutorial_page.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart'
    show
        FlutterError,
        Key,
        MaterialApp,
        StatelessWidget,
        Widget,
        WidgetsFlutterBinding,
        runApp;
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await configureDependencies();
  MobileAds.instance.initialize().then((status) {
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        testDeviceIds: <String>['E5BCE9B277498E2110B5F4F43C1A0E6C'],
      ),
    );
  });

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget initialPage() {
    if (!serviceLocator.get<SharedPref>().habitTutorial &&
        !serviceLocator.get<IFireAuth>().isLogged()) {
      return const TutorialPage();
    } else if (!serviceLocator.get<IFireAuth>().isLogged()) {
      return const LoginPage();
    } else {
      return const HomePage();
    }
  }

  @override
  Widget build(context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );

    return AppTheme(
      initialTheme:
          getThemeType(serviceLocator.get<SharedPref>().theme).toThemeMode,
      themeChanged: (theme) {
        serviceLocator
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
            analytics: serviceLocator.get<IFireAnalytics>().analytics,
          )
        ],
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
