import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetHabitUsecase extends BaseUsecase<String, Habit> {
  GetHabitUsecase(this._habitsRepository);

  final IHabitsRepository _habitsRepository;

  @override
  Future<Habit> getRawFuture(String params) {
    return _habitsRepository.getHabit(params);
  }
}
