import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/controllers/ScoreControl.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
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

  final Memory memory = Memory.getInstance;
  final PersonUseCase _personUseCase = PersonUseCase.getInstance;

  // Habit

  Future<Result<List<Habit>>> getHabits() => safeCall(() async {
        if (memory.habits.isEmpty) {
          var data = await FireDatabase().getHabits();
          memory.habits = data;
          return Result.success(data);
        } else {
          return Result.success(memory.habits);
        }
      });

  Future<Result<Habit>> getHabit(String id) => safeCall(() async {
        var data = await FireDatabase().getHabit(id);

        int index = memory.habits.indexWhere((e) => e.id == id);
        if (index == -1) {
          memory.habits.add(data);
        } else {
          memory.habits[index] = data;
        }
        return Result.success(data);
      });

  Future<Result<Habit>> addHabit(Habit habit, List<Reminder> reminders) =>
      safeCall(() async {
        var data = await FireDatabase().addHabit(habit);
        FireAnalytics().sendNewHabit(
            habit.habit,
            AppColors.habitsColorName[habit.colorCode],
            habit.frequency.runtimeType == DayWeek
                ? "Diariamente"
                : "Semanalmente",
            habit.frequency.daysCount(),
            reminders.length != 0 ? "Sim" : "Não");

        memory.habits.add(data);

        return Result.success(data);
      });

  Future<Result<void>> completeHabit(String habitId, DateTime date,
          [bool isAdd = true, List<DateTime> daysDone]) =>
      safeCall(() async {
        return (await getHabit(habitId)).result((habit) async {
          int weekDay = date.weekday == 7 ? 0 : date.weekday;
          DateTime startDate = date.subtract(Duration(days: weekDay));
          DateTime endDate = date.lastWeekDay();

          List<DateTime> days = daysDone ??
              (await FireDatabase().getDaysDone(habitId, startDate, endDate)).map((e) => e.date);

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
          int index = memory.habits.indexWhere((e) => e.id == habitId);
          if (index != -1) {
            memory.habits[index].score = habitScore;
            memory.habits[index].daysDone = habitDaysDone;
            if (isLastDone) memory.habits[index].lastDone = isAdd ? date : null;
          }
          return Result.success(null);
        }, (error) => throw error);
      });

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
