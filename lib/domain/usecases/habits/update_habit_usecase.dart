import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateHabitUsecase extends BaseUsecase<UpdateHabitParams, void> {
  final IHabitsRepository _habitsRepository;
  final ICompetitionsRepository _competitionsRepository;

  UpdateHabitUsecase(this._habitsRepository, this._competitionsRepository);

  @override
  Future<void> getRawFuture(UpdateHabitParams params) async {
    List<String?> competitions = await _competitionsRepository
        .getCompetitions(false)
        .then((list) => list
            .where((e) => e.getMyCompetitor().habitId == params.habit.id)
            .map((e) => e.id)
            .toList());

    await _habitsRepository.updateHabit(
        params.habit, params.inititalHabit, competitions);
  }
}

class UpdateHabitParams {
  final Habit habit;
  final Habit? inititalHabit;

  UpdateHabitParams({required this.habit, this.inititalHabit});
}
