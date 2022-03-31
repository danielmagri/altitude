import 'package:altitude/data/repository/habits_repository.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/base/base_usecase.dart';

class GetHabitUsecase extends BaseUsecase<String, Habit> {
  final IHabitsRepository _habitsRepository;

  GetHabitUsecase(this._habitsRepository);

  @override
  Future<Habit> getRawFuture(String params) {
    return _habitsRepository.getHabit(params);
  }
}
