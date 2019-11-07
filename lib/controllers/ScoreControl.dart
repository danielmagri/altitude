import 'dart:async';
import 'package:habit/controllers/UserControl.dart';
import 'package:habit/services/Database.dart';
import 'package:habit/services/FireFunctions.dart';
import 'package:habit/services/SharedPref.dart';
import 'package:habit/utils/Util.dart';

class ScoreControl {
  static const int fullDayPoint = 1;
  static const int fullCyclePoint = 10;

  int calculateScore(int id, dynamic freq, int daysDone) {
    if (Util.getTimesDays(freq) == daysDone) {
      return fullDayPoint + fullCyclePoint;
    } else {
      return fullDayPoint;
    }
  }

  Future<int> getScore() async {
    return await SharedPref().getScore();
  }

  Future<bool> setScore(int id, int score, DateTime date) async {
    bool result1 = await SharedPref().setScore(score);
    bool result2 = await DatabaseService().updateScore(id, score, date);
    if (await UserControl().isLogged()) {
      FireFunctions().setScore(await SharedPref().getScore(),
          await DatabaseService().listHabitCompetitions(id, date));
    }
    return result1 && result2 ? true : false;
  }
}
