import 'dart:async';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/controllers/UserControl.dart';
import 'package:altitude/services/Database.dart';
import 'package:altitude/services/FireFunctions.dart';
import 'package:altitude/services/SharedPref.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';

enum ScoreType { ADD, SUBTRACT }

class ScoreControl {
  static const int DAY_DONE_POINT = 2;
  static const int CYCLE_DONE_POINT = 1;

  /// Calcula os pontos a ser adicionado ou retirado
  /// frequency: frequência do hábito
  /// week: os dias da semana feito
  /// date: o dia a ser adicionado ou removido
  int calculateScore(ScoreType type, Frequency frequency, List<DayDone> week, DateTime date) {
    if (type == ScoreType.ADD) week.add(DayDone(dateDone: date));

    if (frequency is DayWeek) {
      if (!_hasDoneCorrectDayWeek(frequency, week)) {
        return DAY_DONE_POINT;
      } else if (frequency.isADoneDay(date)) {
        return DAY_DONE_POINT + (week.length * CYCLE_DONE_POINT);
      } else {
        return DAY_DONE_POINT + CYCLE_DONE_POINT;
      }
    } else if (frequency is Weekly) {
      if (week.length > frequency.daysCount()) {
        return DAY_DONE_POINT + CYCLE_DONE_POINT;
      } else if (week.length == frequency.daysCount()) {
        return DAY_DONE_POINT + (week.length * CYCLE_DONE_POINT);
      } else {
        return DAY_DONE_POINT;
      }
    } else {
      return 0;
    }
  }

  /// Calcula os pontos da semana toda
  /// frequency: frequência do hábito
  /// daysDone: os dias da semana feito
  int _calculateWeekScore(Frequency frequency, List<DayDone> week) {
    if (frequency is DayWeek) {
      if (_hasDoneCorrectDayWeek(frequency, week)) {
        return week.length * (DAY_DONE_POINT + CYCLE_DONE_POINT);
      } else {
        return week.length * DAY_DONE_POINT;
      }
    } else if (frequency is Weekly) {
      if (week.length >= frequency.daysCount()) {
        return week.length * (DAY_DONE_POINT + CYCLE_DONE_POINT);
      } else {
        return week.length * DAY_DONE_POINT;
      }
    } else {
      return 0;
    }
  }

  /// Calcula toda a pontuação
  int scoreEarnedTotal(Frequency frequency, List<DayDone> daysDone) {
    int score = 0;
    int index = 0;
    daysDone.sort((a, b) => a.dateDone.compareTo(b.dateDone));

    while (index < daysDone.length) {
      DateTime nextWeek = daysDone[index].dateDone.lastWeekDay().add(Duration(days: 1));
      int lastIndexOfWeek = daysDone.lastIndexWhere((dayDone) => dayDone.dateDone.isBefore(nextWeek));

      if (lastIndexOfWeek != -1) {
        score += _calculateWeekScore(frequency, daysDone.sublist(index, lastIndexOfWeek + 1));
        index = lastIndexOfWeek + 1;
      } else {
        print("lastIndexOfWeek = -1");
        break;
      }
    }

    return score;
  }

  /// Checa se a frequêcia do DayWeek está completa
  bool _hasDoneCorrectDayWeek(DayWeek dayWeek, List<DayDone> week) {
    if (dayWeek.monday == 1 && !week.any((dayDone) => dayDone.dateDone.weekday == 1)) return false;
    if (dayWeek.tuesday == 1 && !week.any((dayDone) => dayDone.dateDone.weekday == 2)) return false;
    if (dayWeek.wednesday == 1 && !week.any((dayDone) => dayDone.dateDone.weekday == 3)) return false;
    if (dayWeek.thursday == 1 && !week.any((dayDone) => dayDone.dateDone.weekday == 4)) return false;
    if (dayWeek.friday == 1 && !week.any((dayDone) => dayDone.dateDone.weekday == 5)) return false;
    if (dayWeek.saturday == 1 && !week.any((dayDone) => dayDone.dateDone.weekday == 6)) return false;
    if (dayWeek.sunday == 1 && !week.any((dayDone) => dayDone.dateDone.weekday == 7)) return false;
    return true;
  }

  Future<int> getScore() async {
    return await SharedPref().getScore();
  }

  Future<bool> setScore(int id, int score, DateTime date) async {
    bool result1 = await SharedPref().setScore(score);
    bool result2 = await DatabaseService().updateScore(id, score, date);
    if (await UserControl().isLogged()) {
      FireFunctions().setScore(await SharedPref().getScore(), await DatabaseService().listHabitCompetitions(id, date));
    }
    return result1 && result2 ? true : false;
  }
}
