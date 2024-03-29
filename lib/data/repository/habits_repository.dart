import 'package:altitude/common/constant/app_colors.dart';
import 'package:altitude/common/enums/score_type.dart';
import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:altitude/data/model/day_done_model.dart';
import 'package:altitude/data/model/habit_model.dart';
import 'package:altitude/data/model/reminder_model.dart';
import 'package:altitude/domain/models/competition_entity.dart';
import 'package:altitude/domain/models/day_done_entity.dart';
import 'package:altitude/domain/models/frequency_entity.dart';
import 'package:altitude/domain/models/habit_entity.dart';
import 'package:altitude/domain/models/reminder_entity.dart';
import 'package:altitude/infra/interface/i_fire_analytics.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:altitude/infra/interface/i_local_notification.dart';
import 'package:altitude/infra/interface/i_score_service.dart';
import 'package:altitude/infra/services/memory.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:injectable/injectable.dart';

abstract class IHabitsRepository {
  Future<List<Habit>> getHabits(bool notSave);
  Future<Habit> getHabit(String id);
  Future<int> completeHabit(
    String habitId,
    int currentScore,
    DateTime date,
    bool isAdd,
    List<DateTime>? daysDone,
    List<Competition> competitions,
  );
  Future<bool> hasDoneAtDay(String id, DateTime date);
  Future<void> updateHabit(
    Habit habit,
    Habit? inititalHabit,
    List<String> competitionsId,
  );
  Future<List<DayDone>> getDaysDone(String? id, DateTime? start, DateTime end);
  Future<void> transferHabit(
    Habit habit,
    List<String> competitionsId,
    List<DayDone> daysDone,
    int? reminderCounter,
  );
  Future<Map<DateTime, List<bool>>> getCalendarDaysDone(
    String id,
    int month,
    int year,
  );
  Future<List<DayDone>> getAllDaysDone(List<Habit> habits);
  Future<void> deleteHabit(Habit habit);
  Future<Habit> addHabit(
    String habit,
    int colorCode,
    Frequency frequency,
    DateTime initialDate,
    Reminder? reminder,
    int? reminderCounter,
  );
  Future<void> updateReminder(
    int? reminderId,
    Habit habit,
    int reminderCounter,
  );
}

@Injectable(as: IHabitsRepository)
class HabitsRepository extends IHabitsRepository {
  HabitsRepository(
    this._memory,
    this._fireDatabase,
    this._scoreService,
    this._localNotification,
    this._fireAnalytics,
  );

  final Memory _memory;
  final IFireDatabase _fireDatabase;
  final IScoreService _scoreService;
  final ILocalNotification _localNotification;
  final IFireAnalytics _fireAnalytics;

  @override
  Future<List<Habit>> getHabits(bool notSave) async {
    if (_memory.habits.isEmpty) {
      var data = await _fireDatabase.getHabits();
      if (!notSave) {
        _memory.habits.addAll(data);
      }
      return data;
    } else {
      return _memory.habits;
    }
  }

  @override
  Future<Habit> getHabit(String id) async {
    var data = await _fireDatabase.getHabit(id);

    int index = _memory.habits.indexWhere((e) => e.id == id);
    if (index == -1) {
      _memory.habits.add(data);
    } else {
      _memory.habits[index] = data;
    }
    return data;
  }

  @override
  Future<int> completeHabit(
    String habitId,
    int currentScore,
    DateTime date,
    bool isAdd,
    List<DateTime>? daysDone,
    List<Competition> competitions,
  ) async {
    final habit = await getHabit(habitId);

    int weekDay = date.weekday == 7 ? 0 : date.weekday;
    DateTime startDate = date.subtract(Duration(days: weekDay));
    DateTime endDate = date.lastWeekDay();

    List<DateTime?> days = daysDone ??
        (await _fireDatabase.getDaysDone(habitId, startDate, endDate))
            .map((e) => e.date)
            .toList();

    var score = _scoreService.calculateScore(
      isAdd ? ScoreType.add : ScoreType.subtract,
      habit.frequency,
      days,
      date,
    );

    bool isLastDone =
        habit.lastDone == null || habit.lastDone!.isBeforeOrSameDay(date);
    DayDone dayDone = DayDone(date: date);

    await _fireDatabase.completeHabit(
      habitId,
      isAdd,
      score,
      isLastDone,
      DayDoneModel.fromEntity(dayDone),
      competitions.map((e) => e.id).toList(),
    );

    _memory.person?.score = currentScore + score;
    int index = _memory.habits.indexWhere((e) => e.id == habitId);
    if (index != -1) {
      _memory.habits[index].score = habit.score + score;
      _memory.habits[index].daysDone =
          isAdd ? habit.daysDone + 1 : habit.daysDone - 1;
      if (isLastDone) _memory.habits[index].lastDone = isAdd ? date : null;
    }

    competitions.forEach((competition) {
      int i = _memory.competitions.indexWhere((e) => e.id == competition.id);
      if (index != -1) {
        _memory.competitions[i].competitors.firstWhere((e) => e.you).score +=
            score;
      }
    });

    if (kDebugMode) {
      print('$date $isAdd - Score: $score  Id: $habitId');
    }

    return score;
  }

  @override
  Future<bool> hasDoneAtDay(String id, DateTime date) async {
    return _fireDatabase.hasDoneAtDay(id, date);
  }

  @override
  Future<void> updateHabit(
    Habit habit,
    Habit? inititalHabit,
    List<String> competitionsId,
  ) async {
    await _fireDatabase.updateHabit(
      HabitModel.fromEntity(habit),
      inititalHabit != null ? HabitModel.fromEntity(inititalHabit) : null,
      competitionsId,
    );
    int index = _memory.habits.indexWhere((e) => e.id == habit.id);
    if (index != -1) {
      _memory.habits[index] = habit;
    }
    if (inititalHabit != null && habit.color != inititalHabit.color) {
      _memory.competitions.clear();
    }
  }

  @override
  Future<List<DayDone>> getDaysDone(String? id, DateTime? start, DateTime end) {
    return _fireDatabase.getDaysDone(id, start, end);
  }

  @override
  Future<void> transferHabit(
    Habit habit,
    List<String> competitionsId,
    List<DayDone> daysDone,
    int? reminderCounter,
  ) async {
    if (habit.reminder != null) {
      await _localNotification.addNotification(HabitModel.fromEntity(habit));
    }

    if (daysDone.length > 450) {
      String id = await _fireDatabase.transferHabit(
        HabitModel.fromEntity(habit),
        reminderCounter,
        competitionsId,
        daysDone
            .sublist(0, 450)
            .map((e) => DayDoneModel.fromEntity(e))
            .toList(),
      );
      await _fireDatabase.transferDayDonePlus(
        id,
        daysDone
            .sublist(450, daysDone.length)
            .map((e) => DayDoneModel.fromEntity(e))
            .toList(),
      );
    } else {
      await _fireDatabase.transferHabit(
        HabitModel.fromEntity(habit),
        reminderCounter,
        competitionsId,
        daysDone.map((e) => DayDoneModel.fromEntity(e)).toList(),
      );
    }
  }

  @override
  Future<Map<DateTime, List<bool>>> getCalendarDaysDone(
    String id,
    int month,
    int year,
  ) async {
    final firstDayMonth = DateTime.utc(year, month);
    final lastDayMonth =
        DateTime.utc(year, month + 1).subtract(const Duration(days: 1));

    DateTime startDate = firstDayMonth.subtract(
      Duration(
        days: firstDayMonth.weekday == 7 ? 1 : firstDayMonth.weekday + 1,
      ),
    );
    DateTime endDate = lastDayMonth.add(
      Duration(
        days: firstDayMonth.weekday == 7 ? 7 : 7 - firstDayMonth.weekday,
      ),
    );
    var data = await _fireDatabase.getDaysDone(id, startDate, endDate);
    Map<DateTime, List<bool>> map = {};
    bool before = false;
    bool after = false;

    for (int i = 0; i < data.length; i++) {
      if (i - 1 >= 0 &&
          data[i].date.difference(data[i - 1].date) ==
              const Duration(days: 1)) {
        before = true;
      } else {
        before = false;
      }

      if (i + 1 < data.length &&
          data[i + 1].date.difference(data[i].date) ==
              const Duration(days: 1)) {
        after = true;
      } else {
        after = false;
      }

      map.putIfAbsent(data[i].date, () => [before, after]);
    }
    return map;
  }

  @override
  Future<List<DayDone>> getAllDaysDone(List<Habit> habits) async {
    List<DayDone> list = [];

    for (Habit habit in habits) {
      list.addAll(
        (await _fireDatabase.getAllDaysDone(habit.id))
            .map((e) => DayDone(date: e.date, habitId: habit.id)),
      );
    }

    return list;
  }

  @override
  Future<void> deleteHabit(Habit habit) async {
    if (habit.reminder != null) {
      _localNotification.removeNotification(habit.reminder!.id);
    }
    _fireAnalytics.sendRemoveHabit(habit.habit);

    await _fireDatabase.deleteHabit(habit.id);

    int index = _memory.habits.indexWhere((e) => e.id == habit.id);
    if (index != -1) {
      _memory.habits.removeAt(index);
    }
  }

  @override
  Future<Habit> addHabit(
    String habit,
    int colorCode,
    Frequency frequency,
    DateTime initialDate,
    Reminder? reminder,
    int? reminderCounter,
  ) async {
    var data = await _fireDatabase.addHabit(
      habit,
      colorCode,
      frequency,
      initialDate,
      reminder,
      reminderCounter,
    );
    _fireAnalytics.sendNewHabit(
      habit,
      AppColors.habitsColorName[colorCode],
      frequency is DayWeek ? 'Diariamente' : 'Semanalmente',
      frequency.daysCount(),
      reminder != null ? 'Sim' : 'Não',
    );

    _memory.habits.add(data);

    if (reminder != null) {
      await _localNotification.addNotification(data);
    }

    return data;
  }

  @override
  Future<void> updateReminder(
    int? reminderId,
    Habit habit,
    int reminderCounter,
  ) async {
    if (reminderId != null) {
      await _localNotification.removeNotification(reminderId);
    }

    if (habit.reminder != null) {
      if (habit.reminder!.id == null) {
        habit.reminder!.id = reminderCounter;
      }

      await _fireDatabase.updateReminder(
        habit.id,
        reminderCounter,
        ReminderModel.fromEntity(habit.reminder!),
      );
      int index = _memory.habits.indexWhere((e) => e.id == habit.id);
      if (index != -1) {
        _memory.habits[index] = habit;
      }
      await _localNotification.addNotification(HabitModel.fromEntity(habit));
    } else {
      await _fireDatabase.updateReminder(habit.id, null, null);
      int index = _memory.habits.indexWhere((e) => e.id == habit.id);
      if (index != -1) {
        _memory.habits[index] = habit;
      }
    }
  }
}
