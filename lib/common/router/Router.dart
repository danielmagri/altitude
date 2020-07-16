import 'package:altitude/common/router/arguments/AllLevelsPageArguments.dart';
import 'package:altitude/common/router/arguments/CompetitionDetailsPageArguments.dart';
import 'package:altitude/common/router/arguments/CreateCompetitionPageArguments.dart';
import 'package:altitude/common/router/arguments/EditHabitPageArguments.dart';
import 'package:altitude/common/router/arguments/HabitDetailsPageArguments.dart';
import 'package:altitude/common/router/arguments/LearnDetailPageArguments.dart';
import 'package:altitude/feature/addHabit/view/page/AddHabitPage.dart';
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
import 'package:altitude/feature/statistics/view/page/StatisticsPage.dart';
import 'package:altitude/feature/learn/view/LearnDetailPage.dart';
import 'package:altitude/feature/learn/view/LearnPage.dart';
import 'package:altitude/feature/setting/view/page/HelpPage.dart';
import 'package:altitude/feature/setting/view/page/SettingsPage.dart';
import 'package:flutter/material.dart' show Center, MaterialPageRoute, Route, RouteSettings, Scaffold, Text;

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage(), settings: RouteSettings(name: 'Home'));
      case 'addHabit':
        var arguments = settings.arguments as bool;
        return MaterialPageRoute(
            builder: (_) => AddHabitPage(backTo: arguments ?? false), settings: RouteSettings(name: 'addHabit'));
      case 'allLevels':
        var arguments = settings.arguments as AllLevelsPageArguments;
        return MaterialPageRoute(builder: (_) => AllLevelsPage(arguments), settings: RouteSettings(name: 'allLevels'));
      case 'statistics':
        return MaterialPageRoute(builder: (_) => Statisticspage(), settings: RouteSettings(name: 'statistics'));
      case 'friends':
        return MaterialPageRoute(builder: (_) => FriendsPage(), settings: RouteSettings(name: 'friends'));
      case 'pendingFriends':
        return MaterialPageRoute(builder: (_) => PendingFriendsPage(), settings: RouteSettings(name: 'pendingFriends'));
      case 'competition':
        return MaterialPageRoute(builder: (_) => CompetitionPage(), settings: RouteSettings(name: 'competition'));
      case 'learn':
        return MaterialPageRoute(builder: (_) => LearnPage(), settings: RouteSettings(name: 'learn'));
      case 'learnDetail':
        var arguments = settings.arguments as LearnDetailPageArguments;
        return MaterialPageRoute(
            builder: (_) => LearnDetailPage(arguments), settings: RouteSettings(name: 'learnDetail'));
      case 'createCompetition':
        var arguments = settings.arguments as CreateCompetitionPageArguments;
        return MaterialPageRoute(
            builder: (_) => CreateCompetitionPage(arguments), settings: RouteSettings(name: 'createCompetition'));
      case 'competitionDetails':
        var arguments = settings.arguments as CompetitionDetailsPageArguments;
        return MaterialPageRoute(
            builder: (_) => CompetitionDetailsPage(arguments), settings: RouteSettings(name: 'competitionDetails'));
      case 'pendingCompetition':
        return MaterialPageRoute(
            builder: (_) => PendingCompetitionPage(), settings: RouteSettings(name: 'pendingCompetition'));
      case 'habitDetails':
        var arguments = settings.arguments as HabitDetailsPageArguments;
        return MaterialPageRoute(
            builder: (_) => HabitDetailsPage(arguments), settings: RouteSettings(name: 'habitDetails'));
      case 'editHabit':
        var arguments = settings.arguments as EditHabitPageArguments;
        return MaterialPageRoute(builder: (_) => EditHabitPage(arguments), settings: RouteSettings(name: 'editHabit'));
      case 'settings':
        return MaterialPageRoute(builder: (_) => SettingsPage(), settings: RouteSettings(name: 'settings'));
      case 'help':
        return MaterialPageRoute(builder: (_) => HelpPage(), settings: RouteSettings(name: 'help'));
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
