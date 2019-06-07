import 'dart:async';
import 'package:habit/controllers/DaysDoneControl.dart';
import 'package:habit/controllers/ScoreControl.dart';
import 'package:habit/controllers/NotificationControl.dart';
import 'package:habit/services/Database.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/DayDone.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/objects/Reminder.dart';
import 'package:habit/controllers/DataPreferences.dart';

class DataControl {
  static final DataControl _singleton = new DataControl._internal();

  factory DataControl() {
    return _singleton;
  }

  DataControl._internal();

  // ***** HABIT *****
  Future<List<Habit>> getAllHabits() async {
    return await DatabaseService().getAllHabits();
  }

  Future<Habit> getHabit(int id) async {
    return await DatabaseService().getHabit(id);
  }

  Future<Map<int, List>> getHabitsToday() async {
    List daysDone = await DatabaseService().getHabitsDoneToday();
    List habits = await DatabaseService().getHabitsToday();

    return {0: habits, 1: daysDone};
  }

  Future<bool> addHabit(Habit habit, dynamic frequency, List<Reminder> reminders) async {
    Map response = await DatabaseService().addHabit(habit, frequency, reminders);
    for (Reminder reminder in response[1]) {
      await NotificationControl().addNotification(reminder.id, reminder.hour, reminder.minute, reminder.weekday, habit);
    }

    return true;
  }

  Future<bool> updateHabit(Habit habit) async {
    return await DatabaseService().updateHabit(habit);
  }

  Future<bool> deleteHabit(int id) async {
    return await DatabaseService().deleteHabit(id);
  }

  // ***** REMINDER *****
  Future<List<Reminder>> getReminders(int id) async {
    return await DatabaseService().getReminders(id);
  }

  Future<bool> addReminders(Habit habit, List<Reminder> reminders) async {
    List<Reminder> remindersAdded = await DatabaseService().addReminders(habit.id, reminders);

    for (Reminder reminder in remindersAdded) {
      await NotificationControl().addNotification(reminder.id, reminder.hour, reminder.minute, reminder.weekday, habit);
    }

    return true;
  }

  Future<bool> deleteReminders(int habitId, List<Reminder> reminders) async {
    for (Reminder reminder in reminders) {
      await NotificationControl().removeNotification(reminder.id);
    }
    return await DatabaseService().deleteAllReminders(habitId);
  }

  // ***** FREQUENCY *****
  Future<dynamic> getFrequency(int id) async {
    return await DatabaseService().getFrequency(id);
  }

  Future<bool> updateFrequency(int id, dynamic frequency, Type typeOldFreq) async {
    return await DatabaseService().updateFrequency(id, frequency, typeOldFreq);
  }

  // ***** DAYDONE *****
  Future<Map<DateTime, List>> getDaysDone(int id) async {
    Map<DateTime, List> map = new Map();
    List<DayDone> list = await DatabaseService().getDaysDone(id);
    bool before = false;
    bool after = false;

    for (int i = 0; i < list.length; i++) {
      if (i - 1 >= 0 && list[i].dateDone.difference(list[i - 1].dateDone) == Duration(days: 1)) {
        before = true;
      } else {
        before = false;
      }

      if (i + 1 < list.length && list[i + 1].dateDone.difference(list[i].dateDone) == Duration(days: 1)) {
        after = true;
      } else {
        after = false;
      }

      map.putIfAbsent(list[i].dateDone, () => [before, after]);
    }
    return map;
  }

  Future<List<DayDone>> getCycleDaysDone(int id, int cycle) async {
    return await DatabaseService().getCycleDaysDone(id, cycle);
  }

  Future<int> setHabitDoneAndScore(int id, int cycle) async {
    dynamic freq = await getFrequency(id);
    Map result;

    if (freq.runtimeType == FreqDayWeek) {
      result = await DaysDoneControl().checkCycleDoneDayWeek(id, cycle);
    } else if (freq.runtimeType == FreqWeekly) {
      result = await DaysDoneControl().checkCycleDoneWeekly(id, cycle);
    } else {
      result = await DaysDoneControl().checkCycleDoneRepeating(id, cycle, freq);
    }

    if (result != null) {
      int score = await ScoreControl().calculateScore(id, freq, result[1]);

      print("Pontuação: $score");
      await DataPreferences().setScore(score);
      await DatabaseService().updateScore(id, score);
      await DatabaseService().habitDone(id, cycle, result[0]);
      return score;
    } else {
      return 0;
    }
  }
}
