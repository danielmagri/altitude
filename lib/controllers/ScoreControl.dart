import 'dart:async';
import 'package:habit/utils/Util.dart';

abstract class ScoreControl {
  static const int fullDayPoint = 1;
  static const int fullCyclePoint = 10;

  static Future<int> calculateScore(int id, dynamic freq, int daysDone) async {
    if (Util.getTimesDays(freq) == daysDone) {
      return fullDayPoint + fullCyclePoint;
    } else {
      return fullDayPoint;
    }
  }
}
