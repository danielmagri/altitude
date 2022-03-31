import 'package:altitude/common/enums/score_type.dart';
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
  Future<int> completeHabit(String habitId, int currentScore, DateTime date,
      bool isAdd, List<DateTime>? daysDone, List<Competition> competitions);
}

@Injectable(as: IHabitsRepository)
class HabitsRepository extends IHabitsRepository {
  final Memory _memory;
  final IFireDatabase _fireDatabase;
  final IScoreService _scoreService;

  HabitsRepository(this._memory, this._fireDatabase, this._scoreService);

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
      List<Competition> competitions) async {
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
        date);

    bool isLastDone =
        habit.lastDone == null || habit.lastDone!.isBeforeOrSameDay(date);
    DayDone dayDone = DayDone(date: date);

    await _fireDatabase.completeHabit(habitId, isAdd, score, isLastDone,
        dayDone, competitions.map((e) => e.id).toList());

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

    print("$date $isAdd - Score: $score  Id: $habitId");

    return score;
  }
}
