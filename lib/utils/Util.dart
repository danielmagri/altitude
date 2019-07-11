import 'package:flutter/material.dart';
import 'package:habit/ui/habitDetailsPage.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Reminder.dart';
import 'package:habit/controllers/DataControl.dart';
import 'package:habit/ui/widgets/Loading.dart';
import 'package:habit/datas/dataHabitDetail.dart';

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
}
