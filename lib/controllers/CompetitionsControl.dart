import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/CompetitionPresentation.dart';
import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/controllers/HabitsControl.dart';
import 'package:altitude/controllers/UserControl.dart';
import 'package:altitude/common/services/Database.dart';
import 'package:altitude/common/services/FireAnalytics.dart';
import 'package:altitude/common/services/FireFunctions.dart';
import 'package:altitude/common/services/FireMenssaging.dart';
import 'package:altitude/common/services/SharedPref.dart';

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
      DateTime date = new DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);

      Competitor competitor = Competitor(
          name: await UserControl().getName(),
          fcmToken: await FireMessaging().getToken(),
          color: habit.color,
          score: await HabitsControl().getHabitScore(habitId, date));

      String id = await FireFunctions().createCompetition(
          title,
          date.millisecondsSinceEpoch,
          competitor,
          invitations,
          invitationsToken);

      FireAnalytics().sendCreateCompetition(title, habit.habit, invitations.length);

      return await DatabaseService()
          .createCompetitition(id, title, habitId, date);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> getPendingCompetitionsStatus() async {
    return await SharedPref().getPendingCompetitions();
  }

  Future<void> setPendingCompetitionsStatus(bool value) async {
    return await SharedPref().setPendingCompetitions(value);
  }

  Future<List<String>> listCompetitionsIds(int habitId) async {
    return await DatabaseService().listCompetitionsIds(habitId: habitId);
  }

  Future<bool> updateCompetition(String id, String title) async {
    var result = await FireFunctions().updateCompetition(id, title);
    if (result) {
      return await DatabaseService().updateCompetition(id, title);
    } else {
      return false;
    }
  }

  Future<bool> updateCompetitionDB(String id, String title) async {
    return await DatabaseService().updateCompetition(id, title);
  }

  Future<List<CompetitionPresentation>> listCompetitions() async {
    return await DatabaseService().listCompetitions();
  }

  Future<Competition> getCompetitionDetail(String id) async {
    return await FireFunctions().getCompetitionDetail(id);
  }

  Future<bool> addCompetitor(String id, String name, List<String> invitations,
      List<String> invitationsToken) async {
    return await FireFunctions()
        .addCompetitor(id, name, invitations, invitationsToken);
  }

  Future<bool> removeCompetitor(String id, String uidCompetitor) async {
    var result = await FireFunctions().removeCompetitor(id, uidCompetitor);

    if (result && uidCompetitor == await UserControl().getUid()) {
      return await DatabaseService().removeCompetition(id);
    } else {
      return result;
    }
  }

  Future<List<Competition>> getPendingCompetitions() async {
    return await FireFunctions().getPendingCompetitions();
  }

  Future<void> acceptCompetitionRequest(
      String id, String title, DateTime date, int habitId) async {
    try {
      Habit habit = await HabitsControl().getHabit(habitId);

      await FireFunctions().acceptCompetitionRequest(
          id,
          await UserControl().getName(),
          await FireMessaging().getToken(),
          habit.color,
          await HabitsControl().getHabitScore(habitId, date));

      return await DatabaseService()
          .createCompetitition(id, title, habitId, date);
    } catch (e) {
      throw e;
    }
  }

  Future<void> declineCompetitionRequest(String id) async {
    return await FireFunctions().declineCompetitionRequest(id);
  }
}
