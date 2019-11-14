import 'package:habit/controllers/HabitsControl.dart';
import 'package:habit/controllers/UserControl.dart';
import 'package:habit/objects/Competition.dart';
import 'package:habit/objects/CompetitionPresentation.dart';
import 'package:habit/objects/Competitor.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/services/Database.dart';
import 'package:habit/services/FireFunctions.dart';
import 'package:habit/services/FireMenssaging.dart';

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
          fcmToken: await FireMessaging().getToken(),
          color: habit.color,
          score: habit.score);

      String id = await FireFunctions()
          .createCompetition(title, competitor, invitations, invitationsToken);

      return await DatabaseService().createCompetitition(id, title, habitId);
    } catch (e) {
      throw e;
    }
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
      String id, String title, int habitId) async {
    try {
      Habit habit = await HabitsControl().getHabit(habitId);

      await FireFunctions().acceptCompetitionRequest(
          id,
          await UserControl().getName(),
          await FireMessaging().getToken(),
          habit.color,
          habit.score);

      return await DatabaseService().createCompetitition(id, title, habitId);
    } catch (e) {
      throw e;
    }
  }

  Future<void> declineCompetitionRequest(String id) async {
    return await FireFunctions().declineCompetitionRequest(id);
  }
}