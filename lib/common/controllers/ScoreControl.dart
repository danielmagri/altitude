import 'dart:async';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/core/services/Database.dart';
import 'package:altitude/core/services/FireFunctions.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';

enum ScoreType { ADD, SUBTRACT }

class ScoreControl {
  final PersonUseCase personUseCase = PersonUseCase.getInstance;

  static const int DAY_DONE_POINT = 2;
  static const int CYCLE_DONE_POINT = 1;

  /// Calcula os pontos a ser adicionado ou retirado
  /// frequency: frequência do hábito
  /// week: os dias da semana feito
  /// date: o dia a ser adicionado ou removido
  int calculateScore(ScoreType type, Frequency frequency, List<DateTime> week, DateTime date) {
    if (type == ScoreType.ADD) week.add(date);

    var signal = type == ScoreType.ADD ? 1 : -1;

    if (frequency is DayWeek) {
      if (!_hasDoneCorrectDayWeek(frequency, week)) {
        return signal * DAY_DONE_POINT;
      } else if (frequency.isADoneDay(date)) {
        return signal * (DAY_DONE_POINT + (week.length * CYCLE_DONE_POINT));
      } else {
        return signal * (DAY_DONE_POINT + CYCLE_DONE_POINT);
      }
    } else if (frequency is Weekly) {
      if (week.length > frequency.daysCount()) {
        return signal * (DAY_DONE_POINT + CYCLE_DONE_POINT);
      } else if (week.length == frequency.daysCount()) {
        return signal * (DAY_DONE_POINT + (week.length * CYCLE_DONE_POINT));
      } else {
        return signal * (DAY_DONE_POINT);
      }
    } else {
      return 0;
    }
  }

  /// Calcula os pontos da semana toda
  /// frequency: frequência do hábito
  /// daysDone: os dias da semana feito
  int _calculateWeekScore(Frequency frequency, List<DateTime> week) {
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
  int scoreEarnedTotal(Frequency frequency, List<DateTime> daysDone) {
    int score = 0;
    int index = 0;
    daysDone.sort((a, b) => a.compareTo(b));

    while (index < daysDone.length) {
      DateTime nextWeek = daysDone[index].lastWeekDay().add(Duration(days: 1));
      int lastIndexOfWeek = daysDone.lastIndexWhere((dayDone) => dayDone.isBefore(nextWeek));

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
  bool _hasDoneCorrectDayWeek(DayWeek dayWeek, List<DateTime> week) {
    if (dayWeek.monday && !week.any((dayDone) => dayDone.weekday == 1)) return false;
    if (dayWeek.tuesday && !week.any((dayDone) => dayDone.weekday == 2)) return false;
    if (dayWeek.wednesday && !week.any((dayDone) => dayDone.weekday == 3)) return false;
    if (dayWeek.thursday && !week.any((dayDone) => dayDone.weekday == 4)) return false;
    if (dayWeek.friday && !week.any((dayDone) => dayDone.weekday == 5)) return false;
    if (dayWeek.saturday && !week.any((dayDone) => dayDone.weekday == 6)) return false;
    if (dayWeek.sunday && !week.any((dayDone) => dayDone.weekday == 7)) return false;
    return true;
  }

  Future<bool> setScore(int id, int score, DateTime date) async {
    SharedPref.instance.addscore(score);
    var oldScore = await DatabaseService().listHabitCompetitions(id, date);
    bool result = await DatabaseService().updateScore(id, score, date);
    if (personUseCase.isLogged) {
      FireFunctions()
          .setScore(SharedPref.instance.score, await DatabaseService().listHabitCompetitions(id, date), oldScore);
    }
    return result ? true : false;
  }
}
