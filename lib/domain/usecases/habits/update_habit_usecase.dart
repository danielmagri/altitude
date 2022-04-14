import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:altitude/domain/models/habit_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateHabitUsecase extends BaseUsecase<UpdateHabitParams, void> {
  UpdateHabitUsecase(
    this._habitsRepository,
    this._competitionsRepository,
    this._userRepository,
  );

  final IHabitsRepository _habitsRepository;
  final ICompetitionsRepository _competitionsRepository;
  final IUserRepository _userRepository;

  @override
  Future<void> getRawFuture(UpdateHabitParams params) async {
    var userUid =
        await _userRepository.getUserData(false).then((value) => value.uid);

    List<String> competitions =
        await _competitionsRepository.getCompetitions(false).then(
              (list) => list
                  .where(
                    (e) =>
                        e.getMyCompetitor(userUid).habitId == params.habit.id,
                  )
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
