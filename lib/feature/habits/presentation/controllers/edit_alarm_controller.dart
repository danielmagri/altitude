import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/common/model/ReminderWeekday.dart';
import 'package:altitude/common/useCase/HabitUseCase.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/feature/habits/domain/enums/reminder_type.dart';
import 'package:altitude/feature/habits/domain/models/reminder_card.dart';
import 'package:altitude/feature/habits/presentation/controllers/habit_details_controller.dart';
import 'package:flutter/material.dart' show Color, TimeOfDay;
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'edit_alarm_controller.g.dart';

@LazySingleton()
class EditAlarmController = _EditAlarmControllerBase with _$EditAlarmController;

abstract class _EditAlarmControllerBase with Store {
  final HabitDetailsController? habitDetailsLogic;
  final HabitUseCase? _habitUseCase;
  final IFireAnalytics? _fireAnalytics;

  Reminder? get reminder => habitDetailsLogic!.reminders.data;
  Color get habitColor => habitDetailsLogic!.habitColor;

  final List<ReminderCard> reminderCards = [
    ReminderCard(ReminderType.HABIT, "Lembrar do hábito"),
    ReminderCard(ReminderType.CUE, "Lembrar do gatilho")
  ];

  @observable
  ReminderType cardTypeSelected = ReminderType.HABIT;

  @observable
  TimeOfDay? reminderTime;

  @computed
  String get timeText =>
      reminderTime!.hour.toString().padLeft(2, '0') + " : " + reminderTime!.minute.toString().padLeft(2, '0');

  List<ReminderWeekday> reminderWeekdaySelection = [
    ReminderWeekday(1, "D", false),
    ReminderWeekday(2, "S", false),
    ReminderWeekday(3, "T", false),
    ReminderWeekday(4, "Q", false),
    ReminderWeekday(5, "Q", false),
    ReminderWeekday(6, "S", false),
    ReminderWeekday(7, "S", false)
  ];

  _EditAlarmControllerBase(this.habitDetailsLogic, this._habitUseCase, this._fireAnalytics) {
    if (reminder != null && reminder!.hasAnyDay()) {
      cardTypeSelected = ReminderType.values.firstWhere((type) => type.value == reminder!.type);
      reminderTime = TimeOfDay(hour: reminder!.hour!, minute: reminder!.minute!);
      reminder!.getAllweekdays().forEach((reminder) {
        reminderWeekdaySelection[reminder.value - 1].state = true;
      });
    } else {
      reminderTime = TimeOfDay.now();
    }
  }

  @action
  void switchReminderType(ReminderType type) {
    cardTypeSelected = type;
  }

  @action
  void reminderWeekdayClick(int id, bool state) {
    reminderWeekdaySelection.firstWhere((item) => item.id == id).state = state;
  }

  void updateReminderTime(TimeOfDay? time) {
    if (time != null) reminderTime = time;
  }

  Future<void> saveReminders() async {
    Reminder newReminder = Reminder(
        type: cardTypeSelected.value,
        hour: reminderTime!.hour,
        minute: reminderTime!.minute,
        sunday: reminderWeekdaySelection[0].state,
        monday: reminderWeekdaySelection[1].state,
        tuesday: reminderWeekdaySelection[2].state,
        wednesday: reminderWeekdaySelection[3].state,
        thursday: reminderWeekdaySelection[4].state,
        friday: reminderWeekdaySelection[5].state,
        saturday: reminderWeekdaySelection[6].state);

    Habit habit = habitDetailsLogic!.habit.data!;
    habit.reminder = newReminder;

    return (await _habitUseCase!.updateReminder(reminder?.id, habit)).result((data) {
      habitDetailsLogic!.editAlarmCallback(newReminder);
    }, (error) => throw error);
  }

  Future<bool> removeReminders() async {
    Habit habit = habitDetailsLogic!.habit.data!;
    habit.reminder = null;
    return (await _habitUseCase!.updateReminder(reminder!.id, habit)).result((data) {
      _fireAnalytics!.sendRemoveAlarm(habitDetailsLogic!.habit.data!.habit);
      habitDetailsLogic!.editAlarmCallback(null);
      return true;
    }, ((error) => throw error));
  }
}
