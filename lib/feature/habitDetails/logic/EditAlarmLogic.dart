import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/common/model/ReminderWeekday.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/common/controllers/HabitsControl.dart';
import 'package:altitude/feature/habitDetails/enums/ReminderType.dart';
import 'package:altitude/feature/habitDetails/logic/HabitDetailsLogic.dart';
import 'package:altitude/feature/habitDetails/model/ReminderCard.dart';
import 'package:flutter/material.dart' show Color, TimeOfDay;
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'EditAlarmLogic.g.dart';

class EditAlarmLogic = _EditAlarmLogicBase with _$EditAlarmLogic;

abstract class _EditAlarmLogicBase with Store {
  HabitDetailsLogic habitDetailsLogic = GetIt.I.get<HabitDetailsLogic>();

  ObservableList<Reminder> get reminders => habitDetailsLogic.reminders.data;
  Color get habitColor => habitDetailsLogic.habitColor;

  final List<ReminderCard> reminderCards = [
    ReminderCard(ReminderType.HABIT, "Lembrar do hábito"),
    ReminderCard(ReminderType.CUE, "Lembrar do gatilho")
  ];

  @observable
  ReminderType cardTypeSelected = ReminderType.HABIT;

  @observable
  TimeOfDay reminderTime;

  @computed
  String get timeText =>
      reminderTime.hour.toString().padLeft(2, '0') + " : " + reminderTime.minute.toString().padLeft(2, '0');

  List<ReminderWeekday> reminderWeekdaySelection = [
    ReminderWeekday(1, "D", false),
    ReminderWeekday(2, "S", false),
    ReminderWeekday(3, "T", false),
    ReminderWeekday(4, "Q", false),
    ReminderWeekday(5, "Q", false),
    ReminderWeekday(6, "S", false),
    ReminderWeekday(7, "S", false)
  ];

  _EditAlarmLogicBase() {
    if (reminders != null && reminders.length != 0) {
      cardTypeSelected = ReminderType.values.firstWhere((type) => type.value == reminders[0].type);
      reminderTime = TimeOfDay(hour: reminders[0].hour, minute: reminders[0].minute);
      reminders.forEach((reminder) {
        reminderWeekdaySelection[reminder.weekday - 1].state = true;
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
    reminderWeekdaySelection.firstWhere((item) => item.id == id)?.state = state;
  }

  void updateReminderTime(TimeOfDay time) {
    if (time != null) reminderTime = time;
  }

  Future<void> saveReminders() async {
    if (reminders.length != 0) {
      await HabitsControl().deleteReminders(habitDetailsLogic.habit.data.oldId, reminders);
    }
    List<Reminder> newReminders = List();
    String days = "";
    reminderWeekdaySelection.forEach((item) {
      if (item.state) {
        newReminders.add(Reminder(
            habitId: habitDetailsLogic.habit.data.oldId,
            hour: reminderTime.hour,
            minute: reminderTime.minute,
            weekday: item.id,
            type: cardTypeSelected.value));
        days += item.title;
      } else {
        days += "-";
      }
    });

    List<Reminder> remindersAdded =await HabitsControl().addReminders(habitDetailsLogic.habit.data, newReminders);

    FireAnalytics().sendSetAlarm(
        habitDetailsLogic.habit.data.habit, cardTypeSelected.value, reminderTime.hour, reminderTime.minute, days);

    habitDetailsLogic.editAlarmCallback(remindersAdded.asObservable());
  }

  Future<bool> removeReminders() async {
    bool result = await HabitsControl().deleteReminders(habitDetailsLogic.habit.data.oldId, reminders);
    FireAnalytics().sendRemoveAlarm(habitDetailsLogic.habit.data.habit);
    habitDetailsLogic.editAlarmCallback(ObservableList());
    return result;
  }
}
