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

  Future<Map> checkCycleDoneDayWeek(int id, int cycle) async {
    List<DayDone> days = await DataControl().getCycleDaysDone(id, cycle);

    int weekDay = DateTime.now().weekday;
    // Verifica se está em uma nova semana
    if (weekDay == 7) {
      if (days.any((dayDone) => dayDone.dateDone.isBefore(DateTime.now()))) {
        return {0: true, 1: 0};
      }
    } else {
      if (days.any((dayDone) => dayDone.dateDone.isBefore(DateTime.now().subtract(Duration(days: weekDay))))) {
        return {0: true, 1: 0};
      }
    }

    return {0: false, 1: days.length};
  }

  Future<Map> checkCycleDoneWeekly(int id, int cycle) async {
    List<DayDone> days = await DataControl().getCycleDaysDone(id, cycle);

    int weekDay = DateTime.now().weekday;
    // Verifica se está em uma nova semana
    if (weekDay == 7) {
      if (days.any((dayDone) => dayDone.dateDone.isBefore(DateTime.now()))) {
        return {0: true, 1: 0};
      }
    } else {
      if (days.any((dayDone) => dayDone.dateDone.isBefore(DateTime.now().subtract(Duration(days: weekDay))))) {
        return {0: true, 1: 0};
      }
    }

    return {0: false, 1: days.length};
  }

  Future<Map> checkCycleDoneRepeating(int id, int cycle, FreqRepeating freq) async {
    List<DayDone> days = await DataControl().getCycleDaysDone(id, cycle);

    if (days.any((dayDone) => dayDone.dateDone.isBefore(DateTime.now().subtract(Duration(days: freq.daysCycle))))) {
      return {0: true, 1: 0};
    } else {
      return {0: false, 1: days.length};
    }
  }
}
