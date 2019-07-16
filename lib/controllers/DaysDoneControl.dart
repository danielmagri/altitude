import 'dart:async';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/objects/DayDone.dart';
import 'package:habit/objects/Frequency.dart';

class DaysDoneControl {
  static final DaysDoneControl _singleton = new DaysDoneControl._internal();

  factory DaysDoneControl() {
    return _singleton;
  }

  DaysDoneControl._internal();

  bool checkIsNewCycle(int id, int cycle, dynamic frequency, List<DayDone> daysDone) {
    DateTime now = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (frequency.runtimeType == FreqDayWeek || frequency.runtimeType == FreqWeekly) {
      int weekDay = now.weekday;
      if (weekDay == 7) {
        return true;
      } else {
        if (daysDone.any((dayDone) => dayDone.dateDone.isBefore(now.subtract(Duration(days: weekDay))))) {
          return true;
        }
      }
    } else {
      if (daysDone.any((dayDone) => dayDone.dateDone.isBefore(now.subtract(Duration(days: frequency.daysCycle - 1))))) {
        return true;
      }
    }

    return false;
  }
}
