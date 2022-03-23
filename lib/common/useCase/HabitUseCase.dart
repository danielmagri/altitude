import 'package:altitude/common/controllers/LevelControl.dart';
import 'package:altitude/common/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/model/pair.dart';
import 'package:altitude/common/controllers/ScoreControl.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/core/base/BaseUseCase.dart';
import 'package:altitude/core/model/result.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_local_notification.dart';
import 'package:altitude/common/constant/app_colors.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@deprecated
@usecase
@Injectable()
class HabitUseCase extends BaseUseCase {
  static HabitUseCase get getI => GetIt.I.get<HabitUseCase>();

  final Memory _memory;
  final IFireDatabase _fireDatabase;
  final ILocalNotification _localNotification;
  final IFireAnalytics _fireAnalytics;
  final GetUserDataUsecase _getUserDataUsecase;
  final GetCompetitionsUsecase _getCompetitionsUsecase;

  HabitUseCase(
    this._memory,
    this._fireDatabase,
    this._localNotification,
    this._fireAnalytics,
    this._getUserDataUsecase,
    this._getCompetitionsUsecase,
  );

  // Transfer data

  Future<Result> transferHabit(
          Habit habit, List<String?> competitionsId, List<DayDone> daysDone) =>
      safeCall(() async {
        int? reminderCounter;
        if (habit.reminder != null) {
          reminderCounter = await _getReminderCounter();
          habit.reminder!.id = reminderCounter;
        }

        if (habit.reminder != null) {
          await _localNotification.addNotification(habit);
        }

        if (daysDone.length > 450) {
          String id = await _fireDatabase.transferHabit(
              habit, reminderCounter, competitionsId, daysDone.sublist(0, 450));
          return _fireDatabase.transferDayDonePlus(
              id, daysDone.sublist(450, daysDone.length));
        } else {
          return _fireDatabase.transferHabit(
              habit, reminderCounter, competitionsId, daysDone);
        }
      });

  Future<Result> updateTotalScore(int? score) => safeCall(() {
        _memory.clear();
        return _fireDatabase.updateTotalScore(
            score, LevelControl.getLevel(score!));
      });

  Future<Result> recalculateScore() => safeCall(() async {
        int totalScore = 0;
        _memory.clear();

        List<Habit> habits = await _fireDatabase.getHabits();
        List<Competition> competitions = await _fireDatabase.getCompetitions();

        for (Habit habit in habits) {
          List<DayDone> daysDone = await _fireDatabase.getAllDaysDone(habit.id);

          int score = ScoreControl().scoreEarnedTotal(
              habit.frequency, daysDone.map((e) => e.date).toList());
          totalScore += score;

          List<Pair<String?, int>> competitionsScore = [];

          for (Competition competition in competitions
              .where((e) => e.getMyCompetitor().habitId == habit.id)
              .toList()) {
            int competitionScore = ScoreControl().scoreEarnedTotal(
                habit.frequency,
                daysDone
                    .where((e) =>
                        e.date!.isAfterOrSameDay(competition.initialDate))
                    .map((e) => e.date)
                    .toList());

            competitionsScore.add(Pair(competition.id, competitionScore));
          }

          await _fireDatabase.updateHabitScore(
              habit.id, score, competitionsScore);
        }

        await _fireDatabase.updateTotalScore(
            totalScore, LevelControl.getLevel(totalScore));

        _memory.clear();
      });

  Future<int?> _getReminderCounter() async {
    Person person = (await _getUserDataUsecase.call(false)).absoluteResult();
    _memory.person?.reminderCounter += 1;
    return person.reminderCounter;
  }

  Future<Result<Habit>> addHabit(Habit habit) => safeCall(() async {
        int? reminderCounter;
        if (habit.reminder != null) {
          reminderCounter = await _getReminderCounter();
          habit.reminder!.id = reminderCounter;
        }
        var data = await _fireDatabase.addHabit(habit, reminderCounter);
        _fireAnalytics.sendNewHabit(
            habit.habit,
            AppColors.habitsColorName[habit.colorCode!],
            habit.frequency.runtimeType == DayWeek
                ? "Diariamente"
                : "Semanalmente",
            habit.frequency!.daysCount(),
            habit.reminder != null ? "Sim" : "Não");

        _memory.habits.add(data);

        if (habit.reminder != null) {
          await _localNotification.addNotification(habit);
        }

        return data;
      });

  Future<Result<void>> updateHabit(Habit habit, [Habit? inititalHabit]) =>
      safeCall(() async {
        List<String?> competitions = (await _getCompetitionsUsecase.call(false))
            .absoluteResult()
            .where((e) => e.getMyCompetitor().habitId == habit.id)
            .map((e) => e.id)
            .toList();
        await _fireDatabase.updateHabit(habit, inititalHabit, competitions);
        int index = _memory.habits.indexWhere((e) => e.id == habit.id);
        if (index != -1) {
          _memory.habits[index] = habit;
        }
        if (inititalHabit != null && habit.color != inititalHabit.color) {
          _memory.competitions.clear();
        }
        return;
      });

  Future<Result<void>> updateReminder(int? reminderId, Habit habit) =>
      safeCall(() async {
        if (reminderId != null) {
          await _localNotification.removeNotification(reminderId);
        }

        if (habit.reminder != null) {
          int? reminderCounter;
          if (habit.reminder!.id == null) {
            reminderCounter = await _getReminderCounter();
            habit.reminder!.id = reminderCounter;
          }

          await _fireDatabase.updateReminder(
              habit.id, reminderCounter, habit.reminder);
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

        return;
      });

  Future<Result<void>> deleteHabit(Habit? habit) => safeCall(() async {
        if (habit!.reminder != null) {
          _localNotification.removeNotification(habit.reminder!.id);
        }
        _fireAnalytics.sendRemoveHabit(habit.habit);

        await _fireDatabase.deleteHabit(habit.id);

        int index = _memory.habits.indexWhere((e) => e.id == habit.id);
        if (index != -1) {
          _memory.habits.removeAt(index);
        }

        return;
      });

  /// Days Done

  Future<Result<List<DayDone>>> getAllDaysDone(List<Habit> habits) =>
      safeCall(() async {
        List<DayDone> list = [];

        for (Habit habit in habits) {
          list.addAll((await _fireDatabase.getAllDaysDone(habit.id))
              .map((e) => DayDone(date: e.date, habitId: habit.id)));
        }

        return list;
      });

  Future<Result<List<DayDone>>> getDaysDone(
          String? id, DateTime? start, DateTime end) =>
      safeCall(() {
        return _fireDatabase.getDaysDone(id, start, end);
      });

  Future<Result<Map<DateTime?, List>>> getCalendarDaysDone(
          String? id, DateTime start, DateTime end) =>
      safeCall(() async {
        DateTime startDate = start.subtract(const Duration(days: 1));
        DateTime endDate = end.add(const Duration(days: 1));
        var data = await _fireDatabase.getDaysDone(id, startDate, endDate);
        Map<DateTime?, List> map = Map();
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

          map.putIfAbsent(data[i].date, () => [before, after]);
        }
        return map;
      });
}
