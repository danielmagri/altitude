import 'dart:math' show Random;
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/common/model/reminder_weekday.dart';
import 'package:altitude/common/model/result.dart';
import 'package:altitude/common/constant/app_colors.dart';
import 'package:altitude/domain/usecases/habits/add_habit_usecase.dart';
import 'package:flutter/material.dart' show Color, TimeOfDay;
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'add_habit_controller.g.dart';

@lazySingleton
class AddHabitController = _AddHabitControllerBase with _$AddHabitController;

abstract class _AddHabitControllerBase with Store {
  final AddHabitUsecase _addHabitUsecase;

  _AddHabitControllerBase(this._addHabitUsecase) {
    color = Random().nextInt(AppColors.habitsColor.length);
    reminderTime = TimeOfDay.now();
  }

  @observable
  int? color;

  @observable
  Frequency? frequency;

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
  TimeOfDay? reminderTime;

  @computed
  String get timeText =>
      reminderTime!.hour.toString().padLeft(2, '0') +
      " : " +
      reminderTime!.minute.toString().padLeft(2, '0');

  @computed
  Color get habitColor => AppColors.habitsColor[color!];

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
    reminderWeekday.firstWhere((item) => item.id == id).state = state;
  }

  @action
  void selectReminderTime(TimeOfDay? time) {
    if (time != null) reminderTime = time;
  }

  Future<Result<Habit>> createHabit(Habit habit) async {
    Reminder reminder = Reminder(
        type: 0,
        hour: reminderTime!.hour,
        minute: reminderTime!.minute,
        sunday: reminderWeekday[0].state,
        monday: reminderWeekday[1].state,
        tuesday: reminderWeekday[2].state,
        wednesday: reminderWeekday[3].state,
        thursday: reminderWeekday[4].state,
        friday: reminderWeekday[5].state,
        saturday: reminderWeekday[6].state);

    if (reminder.hasAnyDay()) habit.reminder = reminder;

    return _addHabitUsecase.call(habit);
  }
}
