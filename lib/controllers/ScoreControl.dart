import 'dart:async';
import 'package:habit/utils/Util.dart';

class ScoreControl {
  static final ScoreControl _singleton = new ScoreControl._internal();

  final int fullDayPoint = 1;
  final int fullWeekPoint = 10;

  factory ScoreControl() {
    return _singleton;
  }

  ScoreControl._internal();

  Future<int> calculateScore(int id, dynamic freq, int daysDone) async {
    if (checkCycleDone(freq, daysDone)) {
      return fullDayPoint + fullWeekPoint;
    } else {
      return fullDayPoint;
    }
  }

  bool checkCycleDone(dynamic freq, int daysDone) {
    if (Util.getTimesDays(freq) == 1 + daysDone) {
      return true;
    } else {
      return false;
    }
  }
}
