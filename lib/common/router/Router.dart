import 'package:altitude/common/router/arguments/AllLevelsPageArguments.dart';
import 'package:altitude/common/router/arguments/EditHabitPageArguments.dart';
import 'package:altitude/common/router/arguments/HabitDetailsPageArguments.dart';
import 'package:altitude/feature/addHabit/addHabitPage.dart';
import 'package:altitude/feature/allLevelsPage.dart';
import 'package:altitude/feature/competition/competitionPage.dart';
import 'package:altitude/feature/editHabit/view/page/EditHabitPage.dart';
import 'package:altitude/feature/friends/friendsPage.dart';
import 'package:altitude/feature/habitDetails/view/page/HabitDetailsPage.dart';
import 'package:altitude/feature/home/view/page/HomePage.dart';
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
        AllLevelsPageArguments arguments = settings.arguments as AllLevelsPageArguments;
        return MaterialPageRoute(builder: (_) => AllLevelsPage(arguments));
      case 'friends':
        return MaterialPageRoute(builder: (_) => FriendsPage());
      case 'competition':
        return MaterialPageRoute(builder: (_) => CompetitionPage());
      case 'habitDetails':
        HabitDetailsPageArguments arguments = settings.arguments as HabitDetailsPageArguments;
        return MaterialPageRoute(builder: (_) => HabitDetailsPage(arguments));
      case 'editHabit':
        EditHabitPageArguments arguments = settings.arguments as EditHabitPageArguments;
        return MaterialPageRoute(builder: (_) => EditHabitPage(arguments));
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
