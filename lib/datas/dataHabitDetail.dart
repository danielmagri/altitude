import 'package:altitude/model/Frequency.dart';
import 'package:flutter/material.dart';
import 'package:altitude/model/Habit.dart';
import 'package:altitude/model/Reminder.dart';
import 'package:altitude/utils/Color.dart';

class DataHabitDetail {
  static final DataHabitDetail _singleton = new DataHabitDetail._internal();

  factory DataHabitDetail() {
    return _singleton;
  }

  DataHabitDetail._internal();

  Habit habit;
  List<Reminder> reminders;
  Frequency frequency;
  Map<DateTime, List> daysDone;
  List<String> competitions;

  Color getColor() {
    return AppColors.habitsColor[habit.color];
  }
}
