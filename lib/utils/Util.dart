import 'package:flutter/material.dart';
import 'package:habit/ui/habitDetailsPage.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Reminder.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/ui/widgets/Loading.dart';
import 'package:habit/datas/dataHabitDetail.dart';
import 'package:habit/objects/Frequency.dart';

abstract class Util {
  static void goDetailsPage(BuildContext context, int id, {bool pushReplacement = false}) async {
    Loading.showLoading(context);

    Habit data = await DataControl().getHabit(id);
    List<Reminder> reminders = await DataControl().getReminders(id);
    dynamic frequency = await DataControl().getFrequency(id);
    Map<DateTime, List> daysDone = await DataControl().getDaysDone(id);

    Loading.closeLoading(context);
    if (data != null && data.id != null && frequency != null && reminders != null) {
      DataHabitDetail().habit = data;
      DataHabitDetail().reminders = reminders;
      DataHabitDetail().frequency = frequency;
      DataHabitDetail().daysDone = daysDone;

      if (pushReplacement) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
          return HabitDetailsPage();
        }));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return HabitDetailsPage();
        }));
      }
    }
  }

  /// Coleta a quatidade de dias a ser feito dentro de um ciclo.
  static int getTimesDays(dynamic frequency) {
    if (frequency.runtimeType == FreqDayWeek) {
      FreqDayWeek freqDayWeek = frequency;
      int sumDays = 0;
      if (freqDayWeek.monday == 1) sumDays++;
      if (freqDayWeek.tuesday == 1) sumDays++;
      if (freqDayWeek.wednesday == 1) sumDays++;
      if (freqDayWeek.thursday == 1) sumDays++;
      if (freqDayWeek.friday == 1) sumDays++;
      if (freqDayWeek.saturday == 1) sumDays++;
      if (freqDayWeek.sunday == 1) sumDays++;

      return sumDays;
    } else if (frequency.runtimeType == FreqWeekly) {
      FreqWeekly freqWeekly = frequency;

      return freqWeekly.daysTime;
    } else {
      FreqRepeating freqRepeating = frequency;

      return freqRepeating.daysTime;
    }
  }

  /// Coleta o tamanho do ciclo em dias.
  static int getDaysCycle(dynamic frequency) {
    if (frequency.runtimeType == FreqDayWeek) {
      return 7;
    } else if (frequency.runtimeType == FreqWeekly) {
      return 7;
    } else {
      FreqRepeating freqRepeating = frequency;

      return freqRepeating.daysCycle;
    }
  }
}
