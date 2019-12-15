import 'dart:async';
import 'package:habit/controllers/ScoreControl.dart';
import 'package:habit/controllers/NotificationControl.dart';
import 'package:habit/enums/DonePageType.dart';
import 'package:habit/services/Database.dart';
import 'package:habit/services/FireAnalytics.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Frequency.dart';
import 'package:habit/objects/DayDone.dart';
import 'package:habit/objects/Reminder.dart';
import 'package:habit/services/FireFunctions.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/utils/Util.dart';

class HabitsControl {
  static final HabitsControl _singleton = new HabitsControl._internal();

  factory HabitsControl() {
    return _singleton;
  }

  HabitsControl._internal();

  /// Retorna a quantidade de hábitos registrados.
  Future<int> getAllHabitCount() async {
    return await DatabaseService().getAllHabitsCount();
  }

  /// Retorna todos os hábitos registrados;
  Future<List<Habit>> getAllHabits() async {
    List habits = await DatabaseService().getAllHabits();

    return habits;
  }

  /// Retorna todos os hábitos registrados e os já feitos hoje.
  /// Ex: {0: todos_os_hábitos(Habit), 1: hábitos_feitos_hoje(DayDone)}
  Future<Map<int, List>> getAllHabitsWithDoneDays() async {
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
  Future<Habit> addHabit(Habit habit, dynamic frequency, List<Reminder> reminders) async {
    Map response = await DatabaseService().addHabit(habit, frequency, reminders);
    habit.id = response[0];
    for (Reminder reminder in response[1]) {
      await NotificationControl().addNotification(reminder, habit);
    }

    FireAnalytics().sendNewHabit(
        habit.habit,
        AppColors.habitsColorName[habit.color],
        frequency.runtimeType == FreqDayWeek ? "Diariamente" : "Semanalmente",
        Util.getTimesDays(frequency),
        reminders.length != 0 ? "Sim" : "Não");
    return habit;
  }

  /// Atualiza o hábito.
  Future<bool> updateHabit(Habit habit, Habit oldHabit) async {
    if (habit.color != oldHabit.color) {
      FireFunctions().updateUser(await DatabaseService().listCompetitionsIds(habitId: habit.id),
          color: habit.color);
    }
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
  Future<bool> deleteHabit(int id, String habit, int score, List<Reminder> reminders) async {
    for (Reminder reminder in reminders) {
      await NotificationControl().removeNotification(reminder.id);
    }
    FireAnalytics().sendRemoveHabit(habit);
    return await DatabaseService().deleteHabit(id);
  }

  /// Retorna a lista de alarmes do hábito.
  Future<List<Reminder>> getReminders(int id) async {
    return await DatabaseService().getReminders(id);
  }

  /// Adiciona os alarmes do hábito.
  Future<List<Reminder>> addReminders(Habit habit, List<Reminder> reminders) async {
    List<Reminder> remindersAdded = await DatabaseService().addReminders(habit.id, reminders);

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
  Future<bool> updateFrequency(int id, dynamic frequency, Type typeOldFreq) async {
    return await DatabaseService().updateFrequency(id, frequency, typeOldFreq);
  }

  /// Retorna um map com os dias feitos do hábito.
  Future<Map<DateTime, List>> getDaysDone(int id, {DateTime startDate, DateTime endDate}) async {
    Map<DateTime, List> map = new Map();
    List<DayDone> list =
        await DatabaseService().getDaysDone(id, startDate: startDate, endDate: endDate);
    bool before = false;
    bool after = false;

    for (int i = 0; i < list.length; i++) {
      if (i - 1 >= 0 && list[i].dateDone.difference(list[i - 1].dateDone) == Duration(days: 1)) {
        before = true;
      } else {
        before = false;
      }

      if (i + 1 < list.length &&
          list[i + 1].dateDone.difference(list[i].dateDone) == Duration(days: 1)) {
        after = true;
      } else {
        after = false;
      }

      map.putIfAbsent(list[i].dateDone, () => [before, after]);
    }
    return map;
  }

  /// Atualiza a pontuação, registra o dia feito e retorna a pontuação adquirida.
  Future<int> setHabitDoneAndScore(DateTime date, int id, DonePageType page,
      {dynamic freq, bool add = true}) async {
    dynamic frequency = freq != null ? freq : await getFrequency(id);
    int weekDay = date.weekday == 7 ? 0 : date.weekday;
    DateTime startDate = date.subtract(Duration(days: weekDay));
    DateTime endDate = date.add(Duration(days: 6 - weekDay));
    int score;

    List<DayDone> daysDone =
        await DatabaseService().getDaysDone(id, startDate: startDate, endDate: endDate);

    if (add) {
      score = ScoreControl().calculateScore(id, frequency, 1 + daysDone.length);
      await ScoreControl().setScore(id, score, date);
      await DatabaseService().setDayDone(id, date);
    } else {
      score = -ScoreControl().calculateScore(id, frequency, daysDone.length);
      await ScoreControl().setScore(id, score, date);
      await DatabaseService().deleteDayDone(id, date);
    }

    FireAnalytics().sendDoneHabit(page.toString(), DateTime.now().hour);

    return score;
  }

  /// Retorna a pontuação contada a partir da data
  Future<int> getHabitScore(int id, DateTime initialDate) async {
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    dynamic frequency = await getFrequency(id);
    int score = 0;

    // Primeira semana
    int weekDay = initialDate.weekday == 7 ? 0 : initialDate.weekday;
    DateTime startDate = initialDate.subtract(Duration(days: weekDay));
    DateTime date = initialDate.add(Duration(days: 6 - weekDay));
    if (date.isAfter(today)) {
      date = today;
    }

    int dayDoneCount =
        (await DatabaseService().getDaysDone(id, startDate: startDate, endDate: date)).length;

    score += dayDoneCount * ScoreControl.fullDayPoint;
    if (Util.getTimesDays(frequency) <= dayDoneCount) score += ScoreControl.fullCyclePoint;

    // Proximas semanas
    date = date.add(Duration(days: 1));
    while (date.isBefore(today)) {
      dayDoneCount = (await DatabaseService()
              .getDaysDone(id, startDate: date, endDate: date.add(Duration(days: 6))))
          .length;

      score += dayDoneCount * ScoreControl.fullDayPoint;
      if (Util.getTimesDays(frequency) <= dayDoneCount) score += ScoreControl.fullCyclePoint;

      date = date.add(Duration(days: 7));
    }

    return score;
  }
}
