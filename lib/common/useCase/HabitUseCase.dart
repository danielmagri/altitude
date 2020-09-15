import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/controllers/NotificationControl.dart';
import 'package:altitude/common/controllers/ScoreControl.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/base/BaseUseCase.dart';
import 'package:altitude/core/model/Result.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/core/services/FireDatabase.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/utils/Color.dart';
import 'package:get_it/get_it.dart';

class HabitUseCase extends BaseUseCase {
  static HabitUseCase get getInstance => GetIt.I.get<HabitUseCase>();

  final Memory _memory = Memory.getInstance;
  final PersonUseCase _personUseCase = PersonUseCase.getInstance;

  // Habit

  Future<Result<List<Habit>>> getHabits() => safeCall(() async {
        if (_memory.habits.isEmpty) {
          var data = await FireDatabase().getHabits();
          _memory.habits = data;
          return Result.success(data);
        } else {
          return Result.success(_memory.habits);
        }
      });

  Future<Result<Habit>> getHabit(String id) => safeCall(() async {
        var data = await FireDatabase().getHabit(id);

        int index = _memory.habits.indexWhere((e) => e.id == id);
        if (index == -1) {
          _memory.habits.add(data);
        } else {
          _memory.habits[index] = data;
        }
        return Result.success(data);
      });

  Future<int> _getReminderCounter() async {
    Person person = (await _personUseCase.getPerson()).absoluteResult();
    _memory.person?.reminderCounter += 1;
    return person.reminderCounter;
  }

  Future<Result<Habit>> addHabit(Habit habit) => safeCall(() async {
        int reminderCounter;
        if (habit.reminder != null) {
          reminderCounter = await _getReminderCounter();
          habit.reminder.id = reminderCounter;
        }
        var data = await FireDatabase().addHabit(habit, reminderCounter);
        FireAnalytics().sendNewHabit(
            habit.habit,
            AppColors.habitsColorName[habit.colorCode],
            habit.frequency.runtimeType == DayWeek
                ? "Diariamente"
                : "Semanalmente",
            habit.frequency.daysCount(),
            habit.reminder != null ? "Sim" : "Não");

        _memory.habits.add(data);
        if (habit.reminder != null) {
          await NotificationControl().addNotification(habit);
        }

        return Result.success(data);
      });

  Future<Result<void>> updateReminder(int reminderId, Habit habit) =>
      safeCall(() async {
        if (reminderId != null) {
          await NotificationControl().removeNotification(reminderId);
        }

        if (habit.reminder != null) {
          int reminderCounter;
          if (habit.reminder.id == null) {
            reminderCounter = await _getReminderCounter();
            habit.reminder.id = reminderCounter;
          }

          await FireDatabase()
              .updateReminder(habit.id, reminderCounter, habit.reminder);
          int index = _memory.habits.indexWhere((e) => e.id == habit.id);
          if (index != -1) {
            _memory.habits[index] = habit;
          }
          await NotificationControl().addNotification(habit);
        } else {
          await FireDatabase().updateReminder(habit.id, null, null);
          int index = _memory.habits.indexWhere((e) => e.id == habit.id);
          if (index != -1) {
            _memory.habits[index] = habit;
          }
        }

        return Result.success(null);
      });

  Future<Result<void>> completeHabit(String habitId, DateTime date,
          [bool isAdd = true, List<DateTime> daysDone]) =>
      safeCall(() async {
        return (await getHabit(habitId)).result((habit) async {
          int weekDay = date.weekday == 7 ? 0 : date.weekday;
          DateTime startDate = date.subtract(Duration(days: weekDay));
          DateTime endDate = date.lastWeekDay();

          List<DateTime> days = daysDone ??
              (await FireDatabase().getDaysDone(habitId, startDate, endDate))
                  .map((e) => e.date);

          var score = ScoreControl().calculateScore(
              isAdd ? ScoreType.ADD : ScoreType.SUBTRACT,
              habit.frequency,
              days,
              date);

          int totalScore = await _personUseCase.getScore() + score;
          int habitScore = habit.score + score;
          int habitDaysDone = isAdd ? habit.daysDone + 1 : habit.daysDone - 1;
          bool isLastDone =
              habit.lastDone == null || habit.lastDone.isBeforeOrSameDay(date);
          DayDone dayDone = DayDone(date: date);

          await FireDatabase().completeHabit(habitId, isAdd, totalScore,
              habitScore, habitDaysDone, isLastDone, dayDone);
          _personUseCase.setLocalScore(totalScore);
          int index = _memory.habits.indexWhere((e) => e.id == habitId);
          if (index != -1) {
            _memory.habits[index].score = habitScore;
            _memory.habits[index].daysDone = habitDaysDone;
            if (isLastDone)
              _memory.habits[index].lastDone = isAdd ? date : null;
          }
          return Result.success(null);
        }, (error) => throw error);
      });

  Future<Result<void>> deleteHabit(Habit habit) => safeCall(() async {
        if (habit.reminder != null) {
          NotificationControl().removeNotification(habit.reminder.id);
        }
        FireAnalytics().sendRemoveHabit(habit.habit);

        await FireDatabase().deleteHabit(habit.id);

        int index = _memory.habits.indexWhere((e) => e.id == habit.id);
        if (index != -1) {
          _memory.habits.removeAt(index);
        }

        return Result.success(null);
      });

  Future<bool> maximumNumberReached() {
    try {
      if (_memory.habits.isEmpty) {
        return FireDatabase().getHabits().then((data) {
          _memory.habits = data;
          return data.length < MAX_HABITS;
        });
      } else {
        return Future.value(_memory.habits.length < MAX_HABITS);
      }
    } catch (e) {
      return Future.value(true);
    }
  }

  /// Days Done

  Future<Result<Map<DateTime, List>>> getCalendarDaysDone(
          String id, DateTime start, DateTime end) =>
      safeCall(() async {
        DateTime startDate = start.subtract(const Duration(days: 1));
        DateTime endDate = end.add(const Duration(days: 1));
        var data = await FireDatabase().getDaysDone(id, startDate, endDate);
        Map<DateTime, List> map = Map();
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
        return Result.success(map);
      });
}
