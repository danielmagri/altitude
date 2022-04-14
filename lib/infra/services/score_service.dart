import 'dart:developer' show log;

import 'package:altitude/common/enums/score_type.dart';
import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:altitude/domain/models/frequency_entity.dart';
import 'package:altitude/infra/interface/i_score_service.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IScoreService)
class ScoreService extends IScoreService {
  @override
  int calculateScore(
    ScoreType type,
    Frequency frequency,
    List<DateTime?> week,
    DateTime date,
  ) {
    if (type == ScoreType.add) week.add(date);

    var signal = type == ScoreType.add ? 1 : -1;

    if (frequency is DayWeek) {
      if (!_hasDoneCorrectDayWeek(frequency, week)) {
        return signal * IScoreService.dayDonePoint;
      } else if (frequency.isADoneDay(date)) {
        return signal *
            (IScoreService.dayDonePoint +
                (week.length * IScoreService.cycleDonePoint));
      } else {
        return signal *
            (IScoreService.dayDonePoint + IScoreService.cycleDonePoint);
      }
    } else if (frequency is Weekly) {
      if (week.length > frequency.daysCount()) {
        return signal *
            (IScoreService.dayDonePoint + IScoreService.cycleDonePoint);
      } else if (week.length == frequency.daysCount()) {
        return signal *
            (IScoreService.dayDonePoint +
                (week.length * IScoreService.cycleDonePoint));
      } else {
        return signal * (IScoreService.dayDonePoint);
      }
    } else {
      return 0;
    }
  }

  @override
  int scoreEarnedTotal(Frequency? frequency, List<DateTime?> daysDone) {
    int score = 0;
    int index = 0;
    daysDone.sort((a, b) => a!.compareTo(b!));

    while (index < daysDone.length) {
      DateTime nextWeek =
          daysDone[index]!.lastWeekDay().add(const Duration(days: 1));
      int lastIndexOfWeek =
          daysDone.lastIndexWhere((dayDone) => dayDone!.isBefore(nextWeek));

      if (lastIndexOfWeek != -1) {
        score += _calculateWeekScore(
          frequency,
          daysDone.sublist(index, lastIndexOfWeek + 1),
        );
        index = lastIndexOfWeek + 1;
      } else {
        log('lastIndexOfWeek = -1');
        break;
      }
    }

    return score;
  }

  /// Calcula os pontos da semana toda
  /// frequency: frequência do hábito
  /// daysDone: os dias da semana feito
  int _calculateWeekScore(Frequency? frequency, List<DateTime?> week) {
    if (frequency is DayWeek) {
      if (_hasDoneCorrectDayWeek(frequency, week)) {
        return week.length *
            (IScoreService.dayDonePoint + IScoreService.cycleDonePoint);
      } else {
        return week.length * IScoreService.dayDonePoint;
      }
    } else if (frequency is Weekly) {
      if (week.length >= frequency.daysCount()) {
        return week.length *
            (IScoreService.dayDonePoint + IScoreService.cycleDonePoint);
      } else {
        return week.length * IScoreService.dayDonePoint;
      }
    } else {
      return 0;
    }
  }

  /// Checa se a frequêcia do DayWeek está completa
  bool _hasDoneCorrectDayWeek(DayWeek dayWeek, List<DateTime?> week) {
    if (dayWeek.monday && !week.any((dayDone) => dayDone!.weekday == 1)) {
      return false;
    }
    if (dayWeek.tuesday && !week.any((dayDone) => dayDone!.weekday == 2)) {
      return false;
    }
    if (dayWeek.wednesday && !week.any((dayDone) => dayDone!.weekday == 3)) {
      return false;
    }
    if (dayWeek.thursday && !week.any((dayDone) => dayDone!.weekday == 4)) {
      return false;
    }
    if (dayWeek.friday && !week.any((dayDone) => dayDone!.weekday == 5)) {
      return false;
    }
    if (dayWeek.saturday && !week.any((dayDone) => dayDone!.weekday == 6)) {
      return false;
    }
    if (dayWeek.sunday && !week.any((dayDone) => dayDone!.weekday == 7)) {
      return false;
    }
    return true;
  }
}
