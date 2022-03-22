import 'package:altitude/common/controllers/ScoreControl.dart';
import 'package:altitude/common/domain/model/params/complete_params.dart';
import 'package:altitude/common/domain/model/params/send_competition_notification_params.dart';
import 'package:altitude/common/domain/usecases/habits/get_habit_usecase.dart';
import 'package:altitude/common/domain/usecases/notifications/send_competition_notification_usecase.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@usecase
@Injectable()
class CompleteHabitUsecase extends BaseUsecase<CompleteParams, void> {
  final Memory _memory;
  final GetHabitUsecase _getHabitUsecase;
  final SendCompetitionNotificationUsecase _sendCompetitionNotificationUsecase;
  final IFireDatabase _fireDatabase;
  final PersonUseCase _personUseCase;
  final CompetitionUseCase _competitionUseCase;

  CompleteHabitUsecase(
      this._memory,
      this._fireDatabase,
      this._personUseCase,
      this._competitionUseCase,
      this._sendCompetitionNotificationUsecase,
      this._getHabitUsecase);

  @override
  Future<void> getRawFuture(CompleteParams params) async {
    return (await _getHabitUsecase.call(params.habitId)).result((habit) async {
      int weekDay = params.date.weekday == 7 ? 0 : params.date.weekday;
      DateTime startDate = params.date.subtract(Duration(days: weekDay));
      DateTime endDate = params.date.lastWeekDay();

      List<DateTime?> days = params.daysDone ??
          (await _fireDatabase.getDaysDone(params.habitId, startDate, endDate))
              .map((e) => e.date)
              .toList();

      var score = ScoreControl().calculateScore(
          params.isAdd ? ScoreType.ADD : ScoreType.SUBTRACT,
          habit.frequency,
          days,
          params.date);

      bool isLastDone = habit.lastDone == null ||
          habit.lastDone!.isBeforeOrSameDay(params.date);
      DayDone dayDone = DayDone(date: params.date);

      List<Competition> competitions =
          (await _competitionUseCase.getCompetitions())
              .absoluteResult()
              .where((e) =>
                  e.getMyCompetitor().habitId == params.habitId &&
                  e.initialDate!.isBeforeOrSameDay(params.date))
              .toList();

      await _fireDatabase.completeHabit(params.habitId, params.isAdd, score,
          isLastDone, dayDone, competitions.map((e) => e.id).toList());

      _sendCompetitionNotificationUsecase.call(
          SendCompetitionNotificationParams(
              earnedScore: score, competitions: competitions));

      _personUseCase.setLocalScore((await _personUseCase.getScore())! + score);
      int index = _memory.habits.indexWhere((e) => e.id == params.habitId);
      if (index != -1) {
        _memory.habits[index].score = habit.score! + score;
        _memory.habits[index].daysDone =
            params.isAdd ? habit.daysDone! + 1 : habit.daysDone! - 1;
        if (isLastDone)
          _memory.habits[index].lastDone = params.isAdd ? params.date : null;
      }

      competitions.forEach((competition) {
        int i = _memory.competitions.indexWhere((e) => e.id == competition.id);
        if (index != -1) {
          _memory.competitions[i].competitors!
              .firstWhere((e) => e.you!)
              .score += score;
        }
      });

      print(
          "${params.date} ${params.isAdd} - Score: $score  Id: ${params.habitId}");

      return;
    }, (error) => throw error);
  }
}
