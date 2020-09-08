import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/model/Result.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/core/services/FireDatabase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/utils/Color.dart';
import 'package:get_it/get_it.dart';

class HabitUseCase {
  static HabitUseCase get getInstance => GetIt.I.get<HabitUseCase>();

  final Memory memory = Memory.getInstance;
  final PersonUseCase _personUseCase = PersonUseCase.getInstance;

  // Habit

  Future<Result<List<Habit>>> getHabits() {
    if (memory.habits.isEmpty) {
      return FireDatabase().getHabits().then((data) {
        memory.habits = data;
        return Result.success(data);
      }).catchError((error) => Result.error(error));
    } else {
      return Future.value(Result.success(memory.habits));
    }
  }

  Future<Result<Habit>> getHabit(String id) {
    return FireDatabase().getHabit(id).then((data) => Result.success(data)).catchError((error) => Result.error(error));
  }

  Future<Result<Habit>> addHabit(Habit habit, List<Reminder> reminders) {
    return FireDatabase().addHabit(habit).then((data) {
      FireAnalytics().sendNewHabit(
          habit.habit,
          AppColors.habitsColorName[habit.colorCode],
          habit.frequency.runtimeType == DayWeek ? "Diariamente" : "Semanalmente",
          habit.frequency.daysCount(),
          reminders.length != 0 ? "Sim" : "Não");

      memory.habits.add(data);

      return Result.success(data);
    }).catchError((error) => Result.error(error));
  }

  Future<Result<void>> completeHabit(String habitId, DateTime date) async {
    return (await getHabit(habitId)).result((habit) async {
      //somar pontuação ganha e somar nos scores

      int totalScore = await _personUseCase.getScore() + 2;
      int habitScore = habit.score + 2;
      DayDone dayDone = DayDone(date: date);

      try {
        await FireDatabase().completeHabit(habitId, totalScore, habitScore, habit.daysDone + 1, dayDone);
        _personUseCase.setLocalScore(totalScore);
        return Result.success(null);
      } catch (e) {
        return Result.error(e);
      }
    }, (error) => Result.error(error));
  }

  Future<bool> maximumNumberReached() {
    try {
      if (memory.habits.isEmpty) {
        return FireDatabase().getHabits().then((data) {
          memory.habits = data;
          return data.length < MAX_HABITS;
        });
      } else {
        return Future.value(memory.habits.length < MAX_HABITS);
      }
    } catch (e) {
      return Future.value(true);
    }
  }

  /// Days Done

  Future<Result<Map<DateTime, List>>> getCalendarDaysDone(String id, int month, int year) {
    DateTime startDate = DateTime(year, month, 1).subtract(const Duration(days: 7));
    DateTime endDate = DateTime(year, month - 1, 0).add(const Duration(days: 7));
    return FireDatabase().getDaysDone(id, startDate, endDate).then((data) {
      Map<DateTime, List> map = Map();
      bool before = false;
      bool after = false;

      for (int i = 0; i < data.length; i++) {
        if (i - 1 >= 0 && data[i].date.difference(data[i - 1].date) == const Duration(days: 1)) {
          before = true;
        } else {
          before = false;
        }

        if (i + 1 < data.length && data[i + 1].date.difference(data[i].date) == const Duration(days: 1)) {
          after = true;
        } else {
          after = false;
        }

        map.putIfAbsent(data[i].date, () => [before, after]);
      }
      return Result.success(map);
    }).catchError((error) => Result.error(error));
  }
}
