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

  /// Retorna todos os hábitos registrados.
  Future<List<Habit>> getAllHabits() async {
    return await DatabaseService().getAllHabits();
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
  Future<bool> addHabit(Habit habit, dynamic frequency, List<Reminder> reminders) async {
    Map response = await DatabaseService().addHabit(habit, frequency, reminders);
    habit.id = response[0];
    for (Reminder reminder in response[1]) {
      await NotificationControl().addNotification(reminder.id, reminder.hour, reminder.minute, reminder.weekday, habit);
    }

    return true;
  }

  /// Atualiza o hábito.
  Future<bool> updateHabit(Habit habit) async {
    return await DatabaseService().updateHabit(habit);
  }

  /// Atualiza o gatilho do hábito.
  Future<bool> updateCue(int id, String cue) async {
    return await DatabaseService().updateCue(id, cue);
  }

  /// Deleta o hábito.
  Future<bool> deleteHabit(int id) async {
    return await DatabaseService().deleteHabit(id);
  }

  /// Retorna a lista de alarmes do hábito.
  Future<List<Reminder>> getReminders(int id) async {
    return await DatabaseService().getReminders(id);
  }

  /// Adiciona os alarmes do hábito.
  Future<bool> addReminders(Habit habit, List<Reminder> reminders) async {
    List<Reminder> remindersAdded = await DatabaseService().addReminders(habit.id, reminders);

    for (Reminder reminder in remindersAdded) {
      await NotificationControl().addNotification(reminder.id, reminder.hour, reminder.minute, reminder.weekday, habit);
    }

    return true;
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
  Future<bool> updateFrequency(int id, dynamic frequency, Type typeOldFreq) async {
    return await DatabaseService().updateFrequency(id, frequency, typeOldFreq);
  }

  /// Retorna um map com os dias feitos do hábito.
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

  /// Retorna uma lista de dias feitos do hábito de um ciclo específico.
  Future<List<DayDone>> getCycleDaysDone(int id, int cycle) async {
    return await DatabaseService().getCycleDaysDone(id, cycle);
  }

  /// Atualiza a pontuação, registra o dia feito e retorna a pontuação adquirida.
  Future<int> setHabitDoneAndScore(int id, int cycle) async {
    dynamic freq = await getFrequency(id);
    List<DayDone> days = await DataControl().getCycleDaysDone(id, cycle);
    bool newCycle = DaysDoneControl().checkIsNewCycle(id, cycle, freq, days);
    int score;

    if (newCycle) {
      score = await ScoreControl().calculateScore(id, freq, 0);
    }else {
      score = await ScoreControl().calculateScore(id, freq, days.length);
    }

    print("Novo ciclo: $newCycle");
    print("Pontuação: $score");
    await DataPreferences().setScore(score);
    await DatabaseService().updateScore(id, score);
    await DatabaseService().habitDone(id, cycle, newCycle);
    return score;
  }
}
