import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/core/services/LocalNotification.dart';
import 'package:altitude/common/controllers/ScoreControl.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/base/BaseUseCase.dart';
import 'package:altitude/core/model/Pair.dart';
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
  final CompetitionUseCase _competitionUseCase = CompetitionUseCase.getInstance;

  // Habit

  Future<Result<List<Habit>>> getHabits({bool notSave = false}) => safeCall(() async {
        if (_memory.habits.isEmpty) {
          var data = await FireDatabase().getHabits();
          if (!notSave) {
            _memory.habits = data;
          }
          return data;
        } else {
          return _memory.habits;
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
        return data;
      });

  Future<int> _getReminderCounter() async {
    Person person = (await _personUseCase.getPerson()).absoluteResult();
    _memory.person?.reminderCounter += 1;
    return person.reminderCounter;
  }

  Future<Result<Habit>> addHabit(Habit habit, {bool notSave = false}) => safeCall(() async {
        int reminderCounter;
        if (habit.reminder != null) {
          reminderCounter = await _getReminderCounter();
          habit.reminder.id = reminderCounter;
        }
        var data = await FireDatabase().addHabit(habit, reminderCounter);
        FireAnalytics().sendNewHabit(
            habit.habit,
            AppColors.habitsColorName[habit.colorCode],
            habit.frequency.runtimeType == DayWeek ? "Diariamente" : "Semanalmente",
            habit.frequency.daysCount(),
            habit.reminder != null ? "Sim" : "Não");

        if (!notSave) {
          _memory.habits.add(data);
        }
        if (habit.reminder != null) {
          await LocalNotification().addNotification(habit);
        }

        return data;
      });

  Future<Result<void>> updateHabit(Habit habit, [Habit inititalHabit]) => safeCall(() async {
        List<String> competitions = (await _competitionUseCase.getCompetitions())
            .absoluteResult()
            .where((e) => e.getMyCompetitor().habitId == habit.id)
            .map((e) => e.id)
            .toList();
        await FireDatabase().updateHabit(habit, inititalHabit, competitions);
        int index = _memory.habits.indexWhere((e) => e.id == habit.id);
        if (index != -1) {
          _memory.habits[index] = habit;
        }
        if (inititalHabit != null && competitions != null && habit.color != inititalHabit.color) {
          _memory.competitions.clear();
        }
        return;
      });

  Future<Result<void>> updateReminder(int reminderId, Habit habit) => safeCall(() async {
        if (reminderId != null) {
          await LocalNotification().removeNotification(reminderId);
        }

        if (habit.reminder != null) {
          int reminderCounter;
          if (habit.reminder.id == null) {
            reminderCounter = await _getReminderCounter();
            habit.reminder.id = reminderCounter;
          }

          await FireDatabase().updateReminder(habit.id, reminderCounter, habit.reminder);
          int index = _memory.habits.indexWhere((e) => e.id == habit.id);
          if (index != -1) {
            _memory.habits[index] = habit;
          }
          await LocalNotification().addNotification(habit);
        } else {
          await FireDatabase().updateReminder(habit.id, null, null);
          int index = _memory.habits.indexWhere((e) => e.id == habit.id);
          if (index != -1) {
            _memory.habits[index] = habit;
          }
        }

        return;
      });

  Future<Result<void>> completeHabit(String habitId, DateTime date, [bool isAdd = true, List<DateTime> daysDone]) =>
      safeCall(() async {
        return (await getHabit(habitId)).result((habit) async {
          int weekDay = date.weekday == 7 ? 0 : date.weekday;
          DateTime startDate = date.subtract(Duration(days: weekDay));
          DateTime endDate = date.lastWeekDay();

          List<DateTime> days =
              daysDone ?? (await FireDatabase().getDaysDone(habitId, startDate, endDate)).map((e) => e.date).toList();

          var score =
              ScoreControl().calculateScore(isAdd ? ScoreType.ADD : ScoreType.SUBTRACT, habit.frequency, days, date);

          int totalScore = await _personUseCase.getScore() + score;
          int habitScore = habit.score + score;
          int habitDaysDone = isAdd ? habit.daysDone + 1 : habit.daysDone - 1;
          bool isLastDone = habit.lastDone == null || habit.lastDone.isBeforeOrSameDay(date);
          DayDone dayDone = DayDone(date: date);

          List<Competition> competitions = (await _competitionUseCase.getCompetitions())
              .absoluteResult()
              .where((e) => e.getMyCompetitor().habitId == habitId && e.initialDate.isBeforeOrSameDay(date))
              .toList();

          List<Pair<String, int>> competitionsScore =
              competitions.map((e) => Pair(e.id, e.getMyCompetitor().score + score)).toList();

          await FireDatabase().completeHabit(
              habitId, isAdd, totalScore, habitScore, habitDaysDone, isLastDone, dayDone, competitionsScore);
          _personUseCase.setLocalScore(totalScore);
          int index = _memory.habits.indexWhere((e) => e.id == habitId);
          if (index != -1) {
            _memory.habits[index].score = habitScore;
            _memory.habits[index].daysDone = habitDaysDone;
            if (isLastDone) _memory.habits[index].lastDone = isAdd ? date : null;
          }

          competitions.forEach((competition) {
            int i = _memory.competitions.indexWhere((e) => e.id == competition.id);
            if (index != -1) {
              _memory.competitions[i].competitors.firstWhere((e) => e.you).score += score;
            }
          });

          print("$date $isAdd - Total score: $totalScore  HabitScore: $habitScore  DaysDone: $habitDaysDone");

          return;
        }, (error) => throw error);
      });

  Future<Result<void>> deleteHabit(Habit habit) => safeCall(() async {
        if (habit.reminder != null) {
          LocalNotification().removeNotification(habit.reminder.id);
        }
        FireAnalytics().sendRemoveHabit(habit.habit);

        await FireDatabase().deleteHabit(habit.id);

        int index = _memory.habits.indexWhere((e) => e.id == habit.id);
        if (index != -1) {
          _memory.habits.removeAt(index);
        }

        return;
      });

  Future<bool> maximumNumberReached() async {
    try {
      int length = (await getHabits()).absoluteResult().length;

      return length >= MAX_HABITS;
    } catch (e) {
      return Future.value(true);
    }
  }

  /// Days Done

  Future<Result<List<DayDone>>> getDaysDone(String id, DateTime start, DateTime end) => safeCall(() {
        return FireDatabase().getDaysDone(id, start, end);
      });

  Future<Result<Map<DateTime, List>>> getCalendarDaysDone(String id, DateTime start, DateTime end) =>
      safeCall(() async {
        DateTime startDate = start.subtract(const Duration(days: 1));
        DateTime endDate = end.add(const Duration(days: 1));
        var data = await FireDatabase().getDaysDone(id, startDate, endDate);
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
        return map;
      });
}
