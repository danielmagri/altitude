import 'dart:async';
import 'package:habit/controllers/ScoreControl.dart';
import 'package:habit/controllers/NotificationControl.dart';
import 'package:habit/services/Database.dart';
import 'package:habit/services/FireAnalytics.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/objects/DayDone.dart';
import 'package:habit/objects/Reminder.dart';
import 'package:habit/controllers/DataPreferences.dart';
import 'package:habit/utils/Util.dart';

class DataControl {
  static final DataControl _singleton = new DataControl._internal();

  factory DataControl() {
    return _singleton;
  }

  DataControl._internal();

  /// Retorna a quantidade de hábitos registrados.
  Future<int> getAllHabitCount() async {
    return await DatabaseService().getAllHabitsCount();
  }

  /// Retorna todos os hábitos registrados e os já feitos hoje.
  /// Ex: {0: todos_os_hábitos(Habit), 1: hábitos_feitos_hoje(DayDone)}
  Future<Map<int, List>> getAllHabits() async {
    List daysDone = await DatabaseService().getHabitsDoneToday();
    List habits = await DatabaseService().getAllHabits();

    return {0: habits, 1: daysDone};
  }

  /// Retorna uma lista com todas as cores
  Future<List<int>> getAllHabitsColor() async {
    return await DatabaseService().getAllHabitsColor();
  }

  /// Retorna os dados de um hábito específico.
  Future<Habit> getHabit(int id) async {
    return await DatabaseService().getHabit(id);
  }

  /// Retorna todos os hábitos para serem feitos hoje e os já feitos hoje.
  /// Ex: {0: hábitos_de_hoje(Habit), 1: hábitos_feitos_hoje(DayDone)}
  Future<Map<int, List>> getHabitsToday() async {
    List daysDone = await DatabaseService().getHabitsDoneToday();
    List habits = await DatabaseService().getHabitsToday();

    return {0: habits, 1: daysDone};
  }

  /// Adiciona um novo hábito com sua frequência e alarmes.
  Future<bool> addHabit(
      Habit habit, dynamic frequency, List<Reminder> reminders) async {
    Map response =
        await DatabaseService().addHabit(habit, frequency, reminders);
    habit.id = response[0];
    for (Reminder reminder in response[1]) {
      await NotificationControl().addNotification(reminder, habit);
    }

    FireAnalytics().sendNewHabit(
        habit.habit,
        habit.color,
        frequency.runtimeType == FreqDayWeek ? 0 : 1,
        Util.getTimesDays(frequency),
        reminders.length != 0 ? true : false);
    return true;
  }

  /// Atualiza o hábito.
  Future<bool> updateHabit(Habit habit) async {
    return await DatabaseService().updateHabit(habit);
  }

  /// Atualiza o gatilho do hábito.
  Future<bool> updateCue(int id, String habit, String cue) async {
    if (cue == null) {
      FireAnalytics().sendRemoveCue(habit);
    } else {
      FireAnalytics().sendSetCue(habit, cue);
    }
    return await DatabaseService().updateCue(id, cue);
  }

  /// Deleta o hábito.
  Future<bool> deleteHabit(int id, int score, List<Reminder> reminders) async {
    for (Reminder reminder in reminders) {
      await NotificationControl().removeNotification(reminder.id);
    }
    await DataPreferences().setScore(-score);
    return await DatabaseService().deleteHabit(id);
  }

  /// Retorna a lista de alarmes do hábito.
  Future<List<Reminder>> getReminders(int id) async {
    return await DatabaseService().getReminders(id);
  }

  /// Adiciona os alarmes do hábito.
  Future<List<Reminder>> addReminders(
      Habit habit, List<Reminder> reminders) async {
    List<Reminder> remindersAdded =
        await DatabaseService().addReminders(habit.id, reminders);

    for (Reminder reminder in remindersAdded) {
      await NotificationControl().addNotification(reminder, habit);
    }

    return remindersAdded;
  }

  /// Deleta os alarmes do hábito.
  Future<bool> deleteReminders(int habitId, List<Reminder> reminders) async {
    for (Reminder reminder in reminders) {
      await NotificationControl().removeNotification(reminder.id);
    }
    return await DatabaseService().deleteAllReminders(habitId);
  }

  /// Retorna a frequência do hábito.
  Future<dynamic> getFrequency(int id) async {
    return await DatabaseService().getFrequency(id);
  }

  /// Atualiza a frequência do hábito.
  Future<bool> updateFrequency(
      int id, dynamic frequency, Type typeOldFreq) async {
    return await DatabaseService().updateFrequency(id, frequency, typeOldFreq);
  }

  /// Retorna um map com os dias feitos do hábito.
  Future<Map<DateTime, List>> getDaysDone(int id,
      {DateTime startDate, DateTime endDate}) async {
    Map<DateTime, List> map = new Map();
    List<DayDone> list = await DatabaseService()
        .getDaysDone(id, startDate: startDate, endDate: endDate);
    bool before = false;
    bool after = false;

    for (int i = 0; i < list.length; i++) {
      if (i - 1 >= 0 &&
          list[i].dateDone.difference(list[i - 1].dateDone) ==
              Duration(days: 1)) {
        before = true;
      } else {
        before = false;
      }

      if (i + 1 < list.length &&
          list[i + 1].dateDone.difference(list[i].dateDone) ==
              Duration(days: 1)) {
        after = true;
      } else {
        after = false;
      }

      map.putIfAbsent(list[i].dateDone, () => [before, after]);
    }
    return map;
  }

  /// Atualiza a pontuação, registra o dia feito e retorna a pontuação adquirida.
  Future<int> setHabitDoneAndScore(DateTime date, int id,
      {dynamic freq, bool add = true}) async {
    dynamic frequency = freq != null ? freq : await getFrequency(id);
    int weekDay = date.weekday == 7 ? 0 : date.weekday;
    DateTime startDate = date.subtract(Duration(days: weekDay));
    DateTime endDate = date.add(Duration(days: 6 - weekDay));
    int score;

    List<DayDone> daysDone = await DatabaseService()
        .getDaysDone(id, startDate: startDate, endDate: endDate);

    if (add) {
      score =
          await ScoreControl.calculateScore(id, frequency, 1 + daysDone.length);
      await DataPreferences().setScore(score);
      await DatabaseService().updateScore(id, score);
      await DatabaseService().setDayDone(id, date);
    } else {
      score =
          -await ScoreControl.calculateScore(id, frequency, daysDone.length);
      await DataPreferences().setScore(score);
      await DatabaseService().updateScore(id, score);
      await DatabaseService().deleteDayDone(id, date);
    }

    FireAnalytics().sendDoneHabit(
        "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}");

    return score;
  }
}
