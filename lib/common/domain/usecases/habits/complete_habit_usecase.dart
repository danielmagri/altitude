import 'package:altitude/common/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/common/domain/usecases/habits/get_habit_usecase.dart';
import 'package:altitude/common/domain/usecases/notifications/send_competition_notification_usecase.dart';
import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/common/enums/score_type.dart';
import 'package:altitude/common/infra/interface/i_score_service.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';

class CompleteHabitUsecase extends BaseUsecase<CompleteParams, void> {
  final Memory _memory;
  final GetHabitUsecase _getHabitUsecase;
  final SendCompetitionNotificationUsecase _sendCompetitionNotificationUsecase;
  final IFireDatabase _fireDatabase;
  final GetCompetitionsUsecase _getCompetitionsUsecase;
  final GetUserDataUsecase _getUserDataUsecase;
  final IScoreService _scoreService;

  CompleteHabitUsecase(
      this._memory,
      this._fireDatabase,
      this._getUserDataUsecase,
      this._sendCompetitionNotificationUsecase,
      this._getHabitUsecase,
      this._getCompetitionsUsecase,
      this._scoreService);

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

      var score = _scoreService.calculateScore(
          params.isAdd ? ScoreType.ADD : ScoreType.SUBTRACT,
          habit.frequency!,
          days,
          params.date);

      bool isLastDone = habit.lastDone == null ||
          habit.lastDone!.isBeforeOrSameDay(params.date);
      DayDone dayDone = DayDone(date: params.date);

      List<Competition> competitions =
          (await _getCompetitionsUsecase.call(false))
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

      _memory.person?.score = ((await _getUserDataUsecase
                      .call(false)
                      .resultComplete((data) => data, (error) => null))
                  ?.score ??
              0) +
          score;
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

class CompleteParams {
  final String habitId;
  final DateTime date;
  final bool isAdd;
  final List<DateTime>? daysDone;

  CompleteParams({
    required this.habitId,
    required this.date,
    this.isAdd = true,
    this.daysDone,
  });
}
