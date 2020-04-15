import 'package:altitude/common/router/arguments/AllLevelsPageArguments.dart';
import 'package:altitude/common/router/arguments/CompetitionDetailsPageArguments.dart';
import 'package:altitude/common/router/arguments/CreateCompetitionPageArguments.dart';
import 'package:altitude/common/router/arguments/EditHabitPageArguments.dart';
import 'package:altitude/common/router/arguments/HabitDetailsPageArguments.dart';
import 'package:altitude/feature/addHabit/addHabitPage.dart';
import 'package:altitude/feature/advertisement/view/page/BuyBookPage.dart';
import 'package:altitude/feature/competition/view/page/CreateCompetitionPage.dart';
import 'package:altitude/feature/competition/view/page/competitionDetailsPage.dart';
import 'package:altitude/feature/competition/view/page/pendingCompetitionPage.dart';
import 'package:altitude/feature/home/view/page/AllLevelsPage.dart';
import 'package:altitude/feature/competition/view/page/competitionPage.dart';
import 'package:altitude/feature/editHabit/view/page/EditHabitPage.dart';
import 'package:altitude/feature/friends/view/page/FriendsPage.dart';
import 'package:altitude/feature/friends/view/page/PendingFriendsPage.dart';
import 'package:altitude/feature/habitDetails/view/page/HabitDetailsPage.dart';
import 'package:altitude/feature/home/view/page/HomePage.dart';
import 'package:altitude/feature/setting/view/page/HelpPage.dart';
import 'package:altitude/feature/setting/view/page/SettingsPage.dart';
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
      case 'pendingFriends':
        return MaterialPageRoute(builder: (_) => PendingFriendsPage());
      case 'competition':
        return MaterialPageRoute(builder: (_) => CompetitionPage());
      case 'createCompetition':
        CreateCompetitionPageArguments arguments = settings.arguments as CreateCompetitionPageArguments;
        return MaterialPageRoute(builder: (_) => CreateCompetitionPage(arguments));
      case 'competitionDetails':
        CompetitionDetailsPageArguments arguments = settings.arguments as CompetitionDetailsPageArguments;
        return MaterialPageRoute(builder: (_) => CompetitionDetailsPage(arguments));
      case 'pendingCompetition':
        return MaterialPageRoute(builder: (_) => PendingCompetitionPage());
      case 'habitDetails':
        HabitDetailsPageArguments arguments = settings.arguments as HabitDetailsPageArguments;
        return MaterialPageRoute(builder: (_) => HabitDetailsPage(arguments));
      case 'editHabit':
        EditHabitPageArguments arguments = settings.arguments as EditHabitPageArguments;
        return MaterialPageRoute(builder: (_) => EditHabitPage(arguments));
      case 'settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case 'help':
        return MaterialPageRoute(builder: (_) => HelpPage());
      case 'buyBook':
        return MaterialPageRoute(builder: (_) => BuyBookPage());
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
