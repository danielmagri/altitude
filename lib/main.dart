import 'package:altitude/feature/home/page/HomePage.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:altitude/feature/tutorialPage.dart';
import 'package:altitude/common/services/SharedPref.dart';
import 'package:altitude/common/services/FireAnalytics.dart';

void main() async {
  bool showTutorial = false;
  WidgetsFlutterBinding.ensureInitialized();
  if (await SharedPref().getName() == null) showTutorial = true;

  runApp(MyApp(
    showTutorial: showTutorial,
  ));
}

class MyApp extends StatelessWidget {
  final bool showTutorial;

  MyApp({@required this.showTutorial});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

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
    );
  }
}
