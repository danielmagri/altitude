import 'package:altitude/common/router/arguments/AllLevelsPageArguments.dart';
import 'package:altitude/common/router/arguments/CompetitionDetailsPageArguments.dart';
import 'package:altitude/common/router/arguments/CreateCompetitionPageArguments.dart';
import 'package:altitude/common/router/arguments/EditHabitPageArguments.dart';
import 'package:altitude/common/router/arguments/HabitDetailsPageArguments.dart';
import 'package:altitude/presentation/competitions/pages/competition_details_page.dart';
import 'package:altitude/presentation/competitions/pages/competition_page.dart';
import 'package:altitude/presentation/competitions/pages/create_competition_page.dart';
import 'package:altitude/presentation/competitions/pages/pending_competition_page.dart';
import 'package:altitude/presentation/friends/pages/friends_page.dart';
import 'package:altitude/presentation/friends/pages/pending_friends_page.dart';
import 'package:altitude/presentation/habits/pages/add_habit_page.dart';
import 'package:altitude/presentation/habits/pages/edit_habit_page.dart';
import 'package:altitude/presentation/habits/pages/habit_details_page.dart';
import 'package:altitude/presentation/home/pages/all_levels_page.dart';
import 'package:altitude/presentation/home/pages/home_page.dart';
import 'package:altitude/presentation/login/pages/login_page.dart';
import 'package:altitude/presentation/setting/pages/help_page.dart';
import 'package:altitude/presentation/setting/pages/settings_page.dart';
import 'package:altitude/presentation/statistics/pages/statistics_page.dart';
import 'package:flutter/material.dart'
    show Center, MaterialPageRoute, Route, RouteSettings, Scaffold, StatefulWidget, Text;

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home':
        return _pageRoute(HomePage(), 'home');
      case 'login':
        return _pageRoute(const LoginPage(), 'login');
      case 'addHabit':
        var arguments = settings.arguments as bool?;
        return _pageRoute(AddHabitPage(backTo: arguments ?? false), 'addHabit');
      case 'allLevels':
        var arguments = settings.arguments as AllLevelsPageArguments?;
        return _pageRoute(AllLevelsPage(arguments), 'allLevels');
      case 'statistics':
        return _pageRoute(const Statisticspage(), 'statistics');
      case 'friends':
        return _pageRoute(const FriendsPage(), 'friends');
      case 'pendingFriends':
        return _pageRoute(const PendingFriendsPage(), 'pendingFriends');
      case 'competition':
        return _pageRoute(const CompetitionPage(), 'competition');
      case 'createCompetition':
        var arguments = settings.arguments as CreateCompetitionPageArguments?;
        return _pageRoute(CreateCompetitionPage(arguments), 'createCompetition');
      case 'competitionDetails':
        var arguments = settings.arguments as CompetitionDetailsPageArguments;
        return _pageRoute(CompetitionDetailsPage(arguments), 'competitionDetails');
      case 'pendingCompetition':
        return _pageRoute(const PendingCompetitionPage(), 'pendingCompetition');
      case 'habitDetails':
        var arguments = settings.arguments as HabitDetailsPageArguments?;
        return _pageRoute(HabitDetailsPage(arguments), 'habitDetails');
      case 'editHabit':
        var arguments = settings.arguments as EditHabitPageArguments?;
        return _pageRoute(EditHabitPage(arguments), 'editHabit');
      case 'settings':
        return _pageRoute(const SettingsPage(), 'settings');
      case 'help':
        return _pageRoute(const HelpPage(), 'help');
      default:
        return _pageRoute(Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))), 'empty');
    }
  }

  static MaterialPageRoute _pageRoute(StatefulWidget widget, String title) =>
      MaterialPageRoute(builder: (_) => widget, settings: RouteSettings(name: title));
}
