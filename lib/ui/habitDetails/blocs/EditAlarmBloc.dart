import 'dart:async';
import 'package:altitude/controllers/HabitsControl.dart';
import 'package:altitude/core/bloc/BlocBase.dart';
import 'package:altitude/model/Habit.dart';
import 'package:altitude/model/Reminder.dart';
import 'package:altitude/services/FireAnalytics.dart';
import 'package:altitude/ui/habitDetails/enums/ReminderType.dart';
import 'package:altitude/ui/habitDetails/model/ReminderCard.dart';
import 'package:altitude/ui/habitDetails/model/ReminderWeekday.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart' show BuildContext, Color, Theme, ThemeData, TimeOfDay, Widget, showTimePicker;

class EditAlarmBloc extends BlocBase {
  final Habit habit;
  final List<Reminder> reminders;
  final Function(List<Reminder>) callback;

  Color get habitColor => AppColors.habitsColor[habit.color];

  TimeOfDay reminderTime;

  ReminderType currentTypeSelected = ReminderType.HABIT;
  final List<ReminderCard> reminderCards = [
    ReminderCard(ReminderType.HABIT, "Lembrar do hábito"),
    ReminderCard(ReminderType.CUE, "Lembrar do gatilho")
  ];

  List<ReminderWeekday> reminderWeekdays = [
    ReminderWeekday(1, "D", false),
    ReminderWeekday(2, "S", false),
    ReminderWeekday(3, "T", false),
    ReminderWeekday(4, "Q", false),
    ReminderWeekday(5, "Q", false),
    ReminderWeekday(6, "S", false),
    ReminderWeekday(7, "S", false)
  ];

  // Reminder Card Type Selected
  StreamController<ReminderType> _reminderCardTypeSelectedStreamController = StreamController();
  Stream<ReminderType> get reminderCardTypeSelectedStream => _reminderCardTypeSelectedStreamController.stream;

  // Reminder weekday selection
  StreamController<List<ReminderWeekday>> _reminderWeekdaySelectionStreamController = StreamController();
  Stream<List<ReminderWeekday>> get reminderWeekdaySelectionStream => _reminderWeekdaySelectionStreamController.stream;

  // Reminder Time
  StreamController<TimeOfDay> _reminderTimeStreamController = StreamController();
  Stream<TimeOfDay> get reminderTimeStream => _reminderTimeStreamController.stream;

  EditAlarmBloc(this.habit, this.reminders, this.callback) {
    if (reminders != null && reminders.length != 0) {
      currentTypeSelected = ReminderType.values.firstWhere((type) => type.value == reminders[0].type);
      reminderTime = TimeOfDay(hour: reminders[0].hour, minute: reminders[0].minute);
      reminders.forEach((reminder) {
        reminderWeekdays[reminder.weekday - 1].state = true;
      });
    } else {
      reminderTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _reminderCardTypeSelectedStreamController.close();
    _reminderTimeStreamController.close();
    _reminderWeekdaySelectionStreamController.close();
  }

  void switchReminderType(ReminderType type) {
    if (type == ReminderType.CUE && habit.cue == "") {
      showToast("Adicione o gatilho primeiro");
      return;
    }
    currentTypeSelected = type;
    _reminderCardTypeSelectedStreamController.sink.add(type);
  }

  void reminderWeekdayClick(int id, bool state) {
    reminderWeekdays.firstWhere((item) => item.id == id)?.state = state;

    _reminderWeekdaySelectionStreamController.sink.add(reminderWeekdays);
  }

  void reminderTimeClick(BuildContext context) {
    showTimePicker(
      initialTime: reminderTime,
      context: context,
      builder: (BuildContext context, Widget child) {
        return Theme(
            data: ThemeData.light().copyWith(
              accentColor: habitColor,
              primaryColor: habitColor,
            ),
            child: child);
      },
    ).then((time) {
      if (time != null) {
        reminderTime = time;
        _reminderTimeStreamController.sink.add(reminderTime);
      }
    });
  }

  void save(BuildContext context) async {
    if (!reminderWeekdays.any((item) => item.state)) {
      showToast("Selecione pelo menos um dia");
    } else {
      showLoading(context);
      if (reminders.length != 0) {
        await HabitsControl().deleteReminders(habit.id, reminders);
      }
      List<Reminder> newReminders = List();
      String days = "";
      reminderWeekdays.forEach((item) {
        if (item.state) {
          newReminders.add(Reminder(
              habitId: habit.id,
              hour: reminderTime.hour,
              minute: reminderTime.minute,
              weekday: item.id,
              type: currentTypeSelected.value));
          days += item.title;
        } else {
          days += "-";
        }
      });

      await HabitsControl().addReminders(habit, newReminders);

      FireAnalytics()
          .sendSetAlarm(habit.habit, currentTypeSelected.value, reminderTime.hour, reminderTime.minute, days);
      showToast("Alarme salvo");
      hideLoading(context);

      callback(newReminders);
    }
  }

  void remove(BuildContext context) {
    showLoading(context);
    HabitsControl().deleteReminders(habit.id, reminders).then((status) {
      hideLoading(context);
      FireAnalytics().sendRemoveAlarm(habit.habit);
      showToast("Alarme removido");
      callback(List());
    });
  }
}
