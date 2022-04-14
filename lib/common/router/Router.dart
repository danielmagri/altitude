import 'package:altitude/common/router/arguments/AllLevelsPageArguments.dart';
import 'package:altitude/common/router/arguments/CompetitionDetailsPageArguments.dart';
import 'package:altitude/common/router/arguments/CreateCompetitionPageArguments.dart';
import 'package:altitude/common/router/arguments/EditHabitPageArguments.dart';
import 'package:altitude/common/router/arguments/HabitDetailsPageArguments.dart';
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
import 'package:altitude/feature/login/view/page/LoginPage.dart';
import 'package:altitude/feature/statistics/view/page/StatisticsPage.dart';
import 'package:altitude/feature/setting/view/page/HelpPage.dart';
import 'package:altitude/feature/setting/view/page/SettingsPage.dart';
import 'package:flutter/material.dart'
    show Center, MaterialPageRoute, Route, RouteSettings, Scaffold, StatefulWidget, Text;

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return _pageRoute(HomePage(), 'home');
      case 'login':
        return _pageRoute(LoginPage(), 'login');
      case 'addHabit':
        var arguments = settings.arguments as bool;
        return _pageRoute(AddHabitPage(backTo: arguments ?? false), 'addHabit');
      case 'allLevels':
        var arguments = settings.arguments as AllLevelsPageArguments;
        return _pageRoute(AllLevelsPage(arguments), 'allLevels');
      case 'statistics':
        return _pageRoute(Statisticspage(), 'statistics');
      case 'friends':
        return _pageRoute(FriendsPage(), 'friends');
      case 'pendingFriends':
        return _pageRoute(PendingFriendsPage(), 'pendingFriends');
      case 'competition':
        return _pageRoute(CompetitionPage(), 'competition');
      case 'createCompetition':
        var arguments = settings.arguments as CreateCompetitionPageArguments;
        return _pageRoute(CreateCompetitionPage(arguments), 'createCompetition');
      case 'competitionDetails':
        var arguments = settings.arguments as CompetitionDetailsPageArguments;
        return _pageRoute(CompetitionDetailsPage(arguments), 'competitionDetails');
      case 'pendingCompetition':
        return _pageRoute(PendingCompetitionPage(), 'pendingCompetition');
      case 'habitDetails':
        var arguments = settings.arguments as HabitDetailsPageArguments;
        return _pageRoute(HabitDetailsPage(arguments), 'habitDetails');
      case 'editHabit':
        var arguments = settings.arguments as EditHabitPageArguments;
        return _pageRoute(EditHabitPage(arguments), 'editHabit');
      case 'settings':
        return _pageRoute(SettingsPage(), 'settings');
      case 'help':
        return _pageRoute(HelpPage(), 'help');
      default:
        return _pageRoute(Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))), 'empty');
    }
  }

  static MaterialPageRoute _pageRoute(StatefulWidget widget, String title) =>
      MaterialPageRoute(builder: (_) => widget, settings: RouteSettings(name: title));
}
