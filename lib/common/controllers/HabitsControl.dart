import 'dart:async';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/common/controllers/NotificationControl.dart';
import 'package:altitude/core/services/Database.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';

@deprecated
class HabitsControl {
  static final HabitsControl _singleton = new HabitsControl._internal();

  factory HabitsControl() {
    return _singleton;
  }

  HabitsControl._internal();

  final PersonUseCase personUseCase = PersonUseCase.getInstance;

  /// Adiciona um novo hábito com sua frequência e alarmes.
  Future<Habit> addHabit(Habit habit, Frequency frequency, List<Reminder> reminders) async {
    // Map response = await DatabaseService().addHabit(habit, frequency, reminders);
    // habit.id = response[0];
    // for (Reminder reminder in response[1]) {
    //   await NotificationControl().addNotification(reminder, habit);
    // }

    // FireAnalytics().sendNewHabit(
    //     habit.habit,
    //     AppColors.habitsColorName[habit.colorCode],
    //     frequency.runtimeType == DayWeek ? "Diariamente" : "Semanalmente",
    //     frequency.daysCount(),
    //     reminders.length != 0 ? "Sim" : "Não");
    return habit;
  }

  /// Retorna a quantidade de hábitos registrados.
  Future<int> getAllHabitCount() async {
    return await DatabaseService().getAllHabitsCount();
  }

  /// Retorna todos os hábitos registrados;
  Future<List<Habit>> getAllHabits() async {
    // List habits = await DatabaseService().getAllHabits();

    return List();
  }

  /// Retorna todos os hábitos para serem feitos hoje.
  // Future<List<Habit>> getHabitsToday() async {
  //   return await DatabaseService().getHabitsToday();
  // }

  /// Retorna todos os hábitos feitos hoje.
  Future<List<DayDone>> getHabitsDoneToday() async {
    return await DatabaseService().getHabitsDoneToday();
  }

  /// Retorna os dados de um hábito específico.
  Future<Habit> getHabit(int id) async {
    return Habit();
  }

  /// Atualiza o hábito.
  Future<bool> updateHabit(Habit habit, Habit oldHabit, List<Reminder> reminders) async {
    // if (habit.color != oldHabit.color) {
    //   if (personUseCase.isLogged)
    //     FireFunctions().updateUser(await DatabaseService().listCompetitionsIds(habitId: habit.oldId), color: habit.colorCode);
    // }

    // for (Reminder reminder in reminders) {
    //   await NotificationControl().removeNotification(reminder.id);
    //   await NotificationControl().addNotification(reminder, habit);
    // }
    // return await DatabaseService().updateHabit(habit);
    return false;
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
  // Future<List<Reminder>> addReminders(Habit habit, List<Reminder> reminders) async {
    // List<Reminder> remindersAdded = await DatabaseService().addReminders(habit.oldId, reminders);

    // for (Reminder reminder in remindersAdded) {
    //   await NotificationControl().addNotification(reminder, habit);
    // }

    // return remindersAdded;
  // }

  /// Deleta os alarmes do hábito.
  Future<bool> deleteReminders(int habitId, List<Reminder> reminders) async {
    for (Reminder reminder in reminders) {
      await NotificationControl().removeNotification(reminder.id);
    }
    return await DatabaseService().deleteAllReminders(habitId);
  }

  /// Retorna a frequência do hábito.
  Future<Frequency> getFrequency(int id) async {
    return await DatabaseService().getFrequency(id);
  }

  /// Atualiza a frequência do hábito.
  Future<bool> updateFrequency(int id, dynamic frequency, Type typeOldFreq) async {
    return await DatabaseService().updateFrequency(id, frequency, typeOldFreq);
  }

  /// Retorna um map com os dias feitos do hábito.
  Future<Map<DateTime, List>> getDaysDone(int id, {DateTime startDate, DateTime endDate}) async {
    Map<DateTime, List> map = new Map();
    List<DayDone> list = await DatabaseService().getDaysDone(id, startDate: startDate, endDate: endDate);
    bool before = false;
    bool after = false;

    for (int i = 0; i < list.length; i++) {
      if (i - 1 >= 0 && list[i].date.difference(list[i - 1].date) == Duration(days: 1)) {
        before = true;
      } else {
        before = false;
      }

      if (i + 1 < list.length && list[i + 1].date.difference(list[i].date) == Duration(days: 1)) {
        after = true;
      } else {
        after = false;
      }

      map.putIfAbsent(list[i].date, () => [before, after]);
    }
    return map;
  }

  /// Retorna um map com os dias feitos.
  Future<List<DayDone>> getAllDaysDone({DateTime startDate, DateTime endDate}) async {
    return await DatabaseService().getAllDaysDone(startDate: startDate, endDate: endDate);
  }

  /// Atualiza a pontuação, registra o dia feito e retorna a pontuação adquirida.
  // Future<int> setHabitDoneAndScore(DateTime date, int id, DonePageType page, {bool add = true}) async {
  //   Frequency frequency = await getFrequency(id);
  //   int weekDay = date.weekday == 7 ? 0 : date.weekday;
  //   DateTime startDate = date.subtract(Duration(days: weekDay));
  //   DateTime endDate = date.lastWeekDay();
  //   int score;

  //   List<DayDone> daysDone = await DatabaseService().getDaysDone(id, startDate: startDate, endDate: endDate);

  //   if (add) {
  //     score = ScoreControl().calculateScore(ScoreType.ADD, frequency, daysDone, date);
  //     await ScoreControl().setScore(id, score, date);
  //     await DatabaseService().setDayDone(id, date);
  //   } else {
  //     score = -ScoreControl().calculateScore(ScoreType.SUBTRACT, frequency, daysDone, date);
  //     await ScoreControl().setScore(id, score, date);
  //     await DatabaseService().deleteDayDone(id, date);
  //   }

  //   FireAnalytics().sendDoneHabit(page.toString(), DateTime.now().hour);

  //   return score;
  // }

  /// Retorna a pontuação contada a partir da data
  Future<int> getHabitScore(int id, DateTime initialDate) async {
    // DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    // dynamic frequency = await getFrequency(id);
    // List<DayDone> daysDone = await DatabaseService().getDaysDone(id, startDate: initialDate, endDate: today);

    // return ScoreControl().scoreEarnedTotal(frequency, daysDone);
    return 0;
  }
}
