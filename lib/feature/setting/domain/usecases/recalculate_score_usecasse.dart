import 'package:altitude/common/controllers/LevelControl.dart';
import 'package:altitude/common/infra/interface/i_score_service.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:altitude/core/model/pair.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class RecalculateScoreUsecase extends BaseUsecase<NoParams, void> {
  final Memory _memory;
  final IFireDatabase _fireDatabase;
  final IScoreService _scoreService;

  RecalculateScoreUsecase(this._memory, this._fireDatabase, this._scoreService);

  @override
  Future<void> getRawFuture(NoParams params) async {
    int totalScore = 0;
    _memory.clear();

    List<Habit> habits = await _fireDatabase.getHabits();
    List<Competition> competitions = await _fireDatabase.getCompetitions();

    for (Habit habit in habits) {
      List<DayDone> daysDone = await _fireDatabase.getAllDaysDone(habit.id);

      int score = _scoreService.scoreEarnedTotal(
          habit.frequency!, daysDone.map((e) => e.date).toList());
      totalScore += score;

      List<Pair<String?, int>> competitionsScore = [];

      for (Competition competition in competitions
          .where((e) => e.getMyCompetitor().habitId == habit.id)
          .toList()) {
        int competitionScore = _scoreService.scoreEarnedTotal(
            habit.frequency!,
            daysDone
                .where((e) => e.date!.isAfterOrSameDay(competition.initialDate))
                .map((e) => e.date)
                .toList());

        competitionsScore.add(Pair(competition.id, competitionScore));
      }

      await _fireDatabase.updateHabitScore(habit.id, score, competitionsScore);
    }

    await _fireDatabase.updateTotalScore(
        totalScore, LevelControl.getLevel(totalScore));

    _memory.clear();
  }
}
