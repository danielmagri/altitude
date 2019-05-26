import 'dart:async';
import 'package:habit/objects/Frequency.dart';

class ScoreControl {
  static final ScoreControl _singleton = new ScoreControl._internal();

  final int fullDayPoint = 1;
  final int fullWeekPoint = 10;

  factory ScoreControl() {
    return _singleton;
  }

  ScoreControl._internal();

  Future<int> calculateScore(int id, dynamic freq, int daysDone) async {

    if (freq.runtimeType == FreqDayWeek) {
      if (await checkCycleDoneDayWeek(id, freq, daysDone)) {
        return fullDayPoint + fullWeekPoint;
      } else {
        return fullDayPoint;
      }
    } else if (freq.runtimeType == FreqWeekly) {
      if (await checkCycleDoneWeekly(id, freq, daysDone)) {
        return fullDayPoint + fullWeekPoint;
      } else {
        return fullDayPoint;
      }
    } else {
      if (await checkCycleDoneRepeating(id, freq, daysDone)) {
        return fullDayPoint + fullWeekPoint;
      } else {
        return fullDayPoint;
      }
    }
  }

  Future<bool> checkCycleDoneDayWeek(int id, FreqDayWeek freq, int daysDone) async {
    // Soma quantas dias da semana devem ser feitos
    int sumDays = 0;
    if (freq.monday == 1) sumDays++;
    if (freq.tuesday == 1) sumDays++;
    if (freq.wednesday == 1) sumDays++;
    if (freq.thursday == 1) sumDays++;
    if (freq.friday == 1) sumDays++;
    if (freq.saturday == 1) sumDays++;
    if (freq.sunday == 1) sumDays++;

    if (sumDays == 1 + daysDone) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkCycleDoneWeekly(int id, FreqWeekly freq, int daysDone) async {
    if (freq.daysTime == 1 + daysDone) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkCycleDoneRepeating(int id, FreqRepeating freq, int daysDone) async {
    if (freq.daysTime == 1 + daysDone) {
      return true;
    } else {
      return false;
    }
  }
}
