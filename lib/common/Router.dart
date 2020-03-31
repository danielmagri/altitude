import 'package:altitude/feature/addHabit/addHabitPage.dart';
import 'package:altitude/feature/allLevelsPage.dart';
import 'package:altitude/feature/competition/competitionPage.dart';
import 'package:altitude/feature/friends/friendsPage.dart';
import 'package:altitude/feature/home/page/HomePage.dart';
import 'package:altitude/feature/settingsPage.dart';
import 'package:flutter/material.dart' show Center, MaterialPageRoute, Route, RouteSettings, Scaffold, Text;

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case 'addHabit':
        return MaterialPageRoute(builder: (_) => AddHabitPage());
      case 'allLevels':
        int score = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => AllLevelsPage(score: score));
      case 'friends':
        return MaterialPageRoute(builder: (_) => FriendsPage());
      case 'competition':
        return MaterialPageRoute(builder: (_) => CompetitionPage());
      case 'settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
