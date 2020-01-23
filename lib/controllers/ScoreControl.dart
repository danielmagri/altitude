import 'dart:async';
import 'package:altitude/controllers/UserControl.dart';
import 'package:altitude/services/Database.dart';
import 'package:altitude/services/FireFunctions.dart';
import 'package:altitude/services/SharedPref.dart';
import 'package:altitude/utils/Constants.dart';
import 'package:altitude/utils/Util.dart';

class ScoreControl {

  int calculateScore(int id, dynamic freq, int daysDone) {
    if (Util.getTimesDays(freq) == daysDone) {
      return DAY_POINT + CYCLE_POINT;
    } else {
      return DAY_POINT;
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
