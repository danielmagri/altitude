import 'package:altitude/common/router/arguments/AllLevelsPageArguments.dart';
import 'package:altitude/common/router/arguments/CompetitionDetailsPageArguments.dart';
import 'package:altitude/common/router/arguments/CreateCompetitionPageArguments.dart';
import 'package:altitude/common/router/arguments/EditHabitPageArguments.dart';
import 'package:altitude/common/router/arguments/HabitDetailsPageArguments.dart';
import 'package:altitude/feature/competitions/presentation/pages/competition_details_page.dart';
import 'package:altitude/feature/competitions/presentation/pages/competition_page.dart';
import 'package:altitude/feature/competitions/presentation/pages/create_competition_page.dart';
import 'package:altitude/feature/competitions/presentation/pages/pending_competition_page.dart';
import 'package:altitude/feature/friends/presentation/pages/friends_page.dart';
import 'package:altitude/feature/friends/presentation/pages/pending_friends_page.dart';
import 'package:altitude/feature/habits/presentation/pages/add_habit_page.dart';
import 'package:altitude/feature/home/presentation/pages/all_levels_page.dart';
import 'package:altitude/feature/habits/presentation/pages/edit_habit_page.dart';
import 'package:altitude/feature/habits/presentation/pages/habit_details_page.dart';
import 'package:altitude/feature/home/presentation/pages/home_page.dart';
import 'package:altitude/feature/login/presentation/pages/login_page.dart';
import 'package:altitude/feature/setting/presentation/pages/help_page.dart';
import 'package:altitude/feature/setting/presentation/pages/settings_page.dart';
import 'package:altitude/feature/statistics/presentation/pages/statistics_page.dart';
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
        var arguments = settings.arguments as bool?;
        return _pageRoute(AddHabitPage(backTo: arguments ?? false), 'addHabit');
      case 'allLevels':
        var arguments = settings.arguments as AllLevelsPageArguments?;
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
        var arguments = settings.arguments as CreateCompetitionPageArguments?;
        return _pageRoute(CreateCompetitionPage(arguments), 'createCompetition');
      case 'competitionDetails':
        var arguments = settings.arguments as CompetitionDetailsPageArguments;
        return _pageRoute(CompetitionDetailsPage(arguments), 'competitionDetails');
      case 'pendingCompetition':
        return _pageRoute(PendingCompetitionPage(), 'pendingCompetition');
      case 'habitDetails':
        var arguments = settings.arguments as HabitDetailsPageArguments?;
        return _pageRoute(HabitDetailsPage(arguments), 'habitDetails');
      case 'editHabit':
        var arguments = settings.arguments as EditHabitPageArguments?;
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
