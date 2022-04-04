import 'package:altitude/common/constant/app_colors.dart';
import 'package:altitude/common/enums/score_type.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/infra/interface/i_fire_analytics.dart';
import 'package:altitude/infra/interface/i_local_notification.dart';
import 'package:altitude/infra/interface/i_score_service.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:altitude/infra/services/Memory.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
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
    List<String?> competitionsId,
  );
  Future<List<DayDone>> getDaysDone(String? id, DateTime? start, DateTime end);
  Future<void> transferHabit(
    Habit habit,
    List<String?> competitionsId,
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
  Future<Habit> addHabit(Habit habit, int? reminderCounter);
  Future<void> updateReminder(
    int? reminderId,
    Habit habit,
    int reminderCounter,
  );
}

@Injectable(as: IHabitsRepository)
class HabitsRepository extends IHabitsRepository {
  final Memory _memory;
  final IFireDatabase _fireDatabase;
  final IScoreService _scoreService;
  final ILocalNotification _localNotification;
  final IFireAnalytics _fireAnalytics;

  HabitsRepository(
    this._memory,
    this._fireDatabase,
    this._scoreService,
    this._localNotification,
    this._fireAnalytics,
  );

  @override
  Future<List<Habit>> getHabits(bool notSave) async {
    if (_memory.habits.isEmpty) {
      var data = await _fireDatabase.getHabits();
      if (!notSave) {
        _memory.habits = data;
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
      isAdd ? ScoreType.ADD : ScoreType.SUBTRACT,
      habit.frequency!,
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
      dayDone,
      competitions.map((e) => e.id).toList(),
    );

    _memory.person?.score = currentScore + score;
    int index = _memory.habits.indexWhere((e) => e.id == habitId);
    if (index != -1) {
      _memory.habits[index].score = habit.score! + score;
      _memory.habits[index].daysDone =
          isAdd ? habit.daysDone! + 1 : habit.daysDone! - 1;
      if (isLastDone) _memory.habits[index].lastDone = isAdd ? date : null;
    }

    competitions.forEach((competition) {
      int i = _memory.competitions.indexWhere((e) => e.id == competition.id);
      if (index != -1) {
        _memory.competitions[i].competitors!.firstWhere((e) => e.you!).score +=
            score;
      }
    });

    print('$date $isAdd - Score: $score  Id: $habitId');

    return score;
  }

  @override
  Future<bool> hasDoneAtDay(String id, DateTime date) async {
    return await _fireDatabase.hasDoneAtDay(id, date);
  }

  @override
  Future<void> updateHabit(
    Habit habit,
    Habit? inititalHabit,
    List<String?> competitionsId,
  ) async {
    await _fireDatabase.updateHabit(habit, inititalHabit, competitionsId);
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
    List<String?> competitionsId,
    List<DayDone> daysDone,
    int? reminderCounter,
  ) async {
    if (habit.reminder != null) {
      await _localNotification.addNotification(habit);
    }

    if (daysDone.length > 450) {
      String id = await _fireDatabase.transferHabit(
        habit,
        reminderCounter,
        competitionsId,
        daysDone.sublist(0, 450),
      );
      await _fireDatabase.transferDayDonePlus(
        id,
        daysDone.sublist(450, daysDone.length),
      );
    } else {
      await _fireDatabase.transferHabit(
        habit,
        reminderCounter,
        competitionsId,
        daysDone,
      );
    }
  }

  @override
  Future<Map<DateTime, List<bool>>> getCalendarDaysDone(
      String id, int month, int year) async {
    final firstDayMonth = DateTime.utc(year, month, 1);
    final lastDayMonth =
        DateTime.utc(year, month + 1, 1).subtract(const Duration(days: 1));

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
          data[i].date!.difference(data[i - 1].date!) ==
              const Duration(days: 1)) {
        before = true;
      } else {
        before = false;
      }

      if (i + 1 < data.length &&
          data[i + 1].date!.difference(data[i].date!) ==
              const Duration(days: 1)) {
        after = true;
      } else {
        after = false;
      }

      map.putIfAbsent(data[i].date!, () => [before, after]);
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
  Future<Habit> addHabit(Habit habit, int? reminderCounter) async {
    var data = await _fireDatabase.addHabit(habit, reminderCounter);
    _fireAnalytics.sendNewHabit(
      habit.habit,
      AppColors.habitsColorName[habit.colorCode!],
      habit.frequency.runtimeType == DayWeek ? 'Diariamente' : 'Semanalmente',
      habit.frequency!.daysCount(),
      habit.reminder != null ? 'Sim' : 'Não',
    );

    _memory.habits.add(data);

    if (habit.reminder != null) {
      await _localNotification.addNotification(habit);
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
        habit.reminder,
      );
      int index = _memory.habits.indexWhere((e) => e.id == habit.id);
      if (index != -1) {
        _memory.habits[index] = habit;
      }
      await _localNotification.addNotification(habit);
    } else {
      await _fireDatabase.updateReminder(habit.id, null, null);
      int index = _memory.habits.indexWhere((e) => e.id == habit.id);
      if (index != -1) {
        _memory.habits[index] = habit;
      }
    }
  }
}
