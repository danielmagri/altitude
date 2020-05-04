import 'dart:math' show Random;
import 'package:altitude/common/controllers/HabitsControl.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/common/model/ReminderWeekday.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart' show Color, TimeOfDay;
import 'package:mobx/mobx.dart';
part 'AddHabitLogic.g.dart';

class AddHabitLogic = _AddHabitLogicBase with _$AddHabitLogic;

abstract class _AddHabitLogicBase with Store {
  @observable
  int color;

  @observable
  Frequency frequency;

  List<ReminderWeekday> reminderWeekday = [
    ReminderWeekday(1, "D", false),
    ReminderWeekday(2, "S", false),
    ReminderWeekday(3, "T", false),
    ReminderWeekday(4, "Q", false),
    ReminderWeekday(5, "Q", false),
    ReminderWeekday(6, "S", false),
    ReminderWeekday(7, "S", false)
  ];

  @observable
  TimeOfDay reminderTime;

  @computed
  String get timeText =>
      reminderTime.hour.toString().padLeft(2, '0') + " : " + reminderTime.minute.toString().padLeft(2, '0');

  @computed
  Color get habitColor => AppColors.habitsColor[color];

  _AddHabitLogicBase() {
    color = Random().nextInt(AppColors.habitsColor.length);
    reminderTime = TimeOfDay.now();
  }

  @action
  void selectColor(int value) {
    color = value;
  }

  @action
  void selectFrequency(Frequency value) {
    frequency = value;
  }

  @action
  void selectReminderDay(int id, bool state) {
    reminderWeekday.firstWhere((item) => item.id == id)?.state = state;
  }

  @action
  void selectReminderTime(TimeOfDay time) {
    if (time != null) reminderTime = time;
  }

  Future<Habit> createHabit(Habit habit) {
    List<Reminder> reminders = List();
    reminderWeekday.forEach((day) { 
      if (day.state) {
        reminders.add(Reminder(hour: reminderTime.hour, minute: reminderTime.minute, weekday: day.id, type: 0));
      }
    });
    return HabitsControl().addHabit(habit, frequency, reminders);
  }
}
