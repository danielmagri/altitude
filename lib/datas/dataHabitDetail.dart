import 'package:flutter/material.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Reminder.dart';
import 'package:habit/utils/Color.dart';

class DataHabitDetail {
  static final DataHabitDetail _singleton = new DataHabitDetail._internal();

  Habit habit;
  List<Reminder> reminders;
  dynamic frequency;
  Map<DateTime, List> daysDone;

  factory DataHabitDetail() {
    return _singleton;
  }

  DataHabitDetail._internal();

  Color getColor() {
    return AppColors.habitsColor[habit.color];
  }
}
