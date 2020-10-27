import 'package:altitude/common/router/Router.dart';
import 'package:altitude/core/services/FireAuth.dart';
import 'package:altitude/core/services/FireMenssaging.dart';
import 'package:altitude/core/GetIt.dart';
import 'package:altitude/feature/home/view/page/HomePage.dart';
import 'package:altitude/feature/login/view/page/LoginPage.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart'
    show Brightness, Color, Colors, FlutterError, MaterialApp, StatelessWidget, ThemeData, Widget, WidgetsFlutterBinding, runApp;
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome, SystemUiOverlayStyle;
import 'package:altitude/feature/tutorialPage.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:get_it/get_it.dart';
import 'common/sharedPref/SharedPref.dart';

void main() async {
  Getit.init();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await GetIt.I.isReady<SharedPref>();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  Widget initialPage() {
    if (!SharedPref.instance.habitTutorial && !FireAuth().isLogged()) {
      return TutorialPage();
    } else if (!FireAuth().isLogged()) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }

  @override
  Widget build(context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    FireMessaging().configure();

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
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: FireAnalytics().analytics)],
      onGenerateRoute: Router.generateRoute,
    );
  }
}
