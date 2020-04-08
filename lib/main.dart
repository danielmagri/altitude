import 'package:altitude/common/router/Router.dart';
import 'package:altitude/common/services/FireMenssaging.dart';
import 'package:altitude/core/GetIt.dart';
import 'package:altitude/feature/home/view/page/HomePage.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:altitude/feature/tutorialPage.dart';
import 'package:altitude/common/services/FireAnalytics.dart';
import 'package:get_it/get_it.dart';
import 'common/sharedPref/SharedPref.dart';

void main() async {
  Getit.init();
  WidgetsFlutterBinding.ensureInitialized();

  await GetIt.I.isReady<SharedPref>();
  runApp(MyApp(showTutorial: GetIt.I.get<SharedPref>().name == null));
}

class MyApp extends StatelessWidget {
  final bool showTutorial;

  MyApp({@required this.showTutorial});

  @override
  Widget build(BuildContext context) {
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
      home: showTutorial ? TutorialPage() : HomePage(),
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: FireAnalytics().analytics)],
      onGenerateRoute: Router.generateRoute,
    );
  }
}
