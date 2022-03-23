import 'package:altitude/common/domain/usecases/competitions/get_competitions_usecase.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class UpdateHabitUsecase extends BaseUsecase<UpdateHabitParams, void> {
  final Memory _memory;
  final IFireDatabase _fireDatabase;
  final GetCompetitionsUsecase _getCompetitionsUsecase;

  UpdateHabitUsecase(
      this._memory, this._fireDatabase, this._getCompetitionsUsecase);

  @override
  Future<void> getRawFuture(UpdateHabitParams params) async {
    List<String?> competitions = (await _getCompetitionsUsecase.call(false))
        .absoluteResult()
        .where((e) => e.getMyCompetitor().habitId == params.habit.id)
        .map((e) => e.id)
        .toList();
    await _fireDatabase.updateHabit(
        params.habit, params.inititalHabit, competitions);
    int index = _memory.habits.indexWhere((e) => e.id == params.habit.id);
    if (index != -1) {
      _memory.habits[index] = params.habit;
    }
    if (params.inititalHabit != null &&
        params.habit.color != params.inititalHabit!.color) {
      _memory.competitions.clear();
    }
  }
}

class UpdateHabitParams {
  final Habit habit;
  final Habit? inititalHabit;

  UpdateHabitParams({required this.habit, this.inititalHabit});
}
