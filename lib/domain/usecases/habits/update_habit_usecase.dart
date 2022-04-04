import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateHabitUsecase extends BaseUsecase<UpdateHabitParams, void> {
  UpdateHabitUsecase(this._habitsRepository, this._competitionsRepository);

  final IHabitsRepository _habitsRepository;
  final ICompetitionsRepository _competitionsRepository;

  @override
  Future<void> getRawFuture(UpdateHabitParams params) async {
    List<String?> competitions =
        await _competitionsRepository.getCompetitions(false).then(
              (list) => list
                  .where((e) => e.getMyCompetitor().habitId == params.habit.id)
                  .map((e) => e.id)
                  .toList(),
            );

    await _habitsRepository.updateHabit(
      params.habit,
      params.inititalHabit,
      competitions,
    );
  }
}

class UpdateHabitParams {
  UpdateHabitParams({required this.habit, this.inititalHabit});

  final Habit habit;
  final Habit? inititalHabit;
}
