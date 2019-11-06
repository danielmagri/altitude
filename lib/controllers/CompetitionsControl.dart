import 'package:habit/controllers/HabitsControl.dart';
import 'package:habit/controllers/UserControl.dart';
import 'package:habit/objects/Competition.dart';
import 'package:habit/objects/CompetitionPresentation.dart';
import 'package:habit/objects/Competitor.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/services/Database.dart';
import 'package:habit/services/FireFunctions.dart';

class CompetitionsControl {
  static final CompetitionsControl _singleton =
      new CompetitionsControl._internal();

  factory CompetitionsControl() {
    return _singleton;
  }

  CompetitionsControl._internal();

  Future<bool> createCompetition(String title, int habitId,
      List<String> invitations, List<String> invitationsToken) async {
    try {
      Habit habit = await HabitsControl().getHabit(habitId);
      Competitor competitor = Competitor(
          name: await UserControl().getName(),
          color: habit.color,
          score: habit.score);

      String id = await FireFunctions()
          .createCompetition(title, competitor, invitations, invitationsToken);

      return await DatabaseService().createCompetitition(id, title, habitId);
    } catch (e) {
      throw e;
    }
  }

  Future<List<CompetitionPresentation>> listCompetitions() async {
    return await DatabaseService().listCompetitions();
  }

  Future<Competition> getCompetitionDetail(String id) async {
    return await FireFunctions().getCompetitionDetail(id);
  }
}
