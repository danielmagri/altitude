import 'package:altitude/common/router/Router.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/feature/home/view/page/HomePage.dart';
import 'package:altitude/feature/login/view/page/LoginPage.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart'
    show
        Brightness,
        Color,
        Colors,
        FlutterError,
        MaterialApp,
        StatelessWidget,
        ThemeData,
        Widget,
        WidgetsFlutterBinding,
        runApp;
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome, SystemUiOverlayStyle;
import 'package:altitude/feature/tutorialPage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'common/sharedPref/SharedPref.dart';
import 'core/di/get_it_config.dart';
import 'core/services/interfaces/i_fire_analytics.dart';

void main() async {
  configureDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await GetIt.I.isReady<SharedPref>();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  Widget initialPage() {
    if (!SharedPref.instance.habitTutorial && !getIt.get<IFireAuth>().isLogged()) {
      return TutorialPage();
    } else if (!getIt.get<IFireAuth>().isLogged()) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }

  @override
  Widget build(context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Color.fromARGB(100, 250, 250, 250),
        systemNavigationBarColor: Color.fromARGB(255, 250, 250, 250),
        systemNavigationBarIconBrightness: Brightness.dark));

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        accentColor: Color.fromARGB(255, 34, 34, 34),
        primaryColor: Colors.white,
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: initialPage(),
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: getIt.get<IFireAnalytics>().analytics)],
      onGenerateRoute: Router.generateRoute,
    );
  }
}
