import 'package:altitude/common/controllers/LevelControl.dart';
import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/model/pair.dart';
import 'package:altitude/common/controllers/ScoreControl.dart';
import 'package:altitude/common/model/DayDone.dart';
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

  HabitUseCase(
    this._memory,
    this._fireDatabase,
    this._localNotification,
    this._fireAnalytics,
    this._getUserDataUsecase,
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

  
}
