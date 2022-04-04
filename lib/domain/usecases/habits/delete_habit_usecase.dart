import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteHabitUsecase extends BaseUsecase<Habit, void> {
  DeleteHabitUsecase(this._habitsRepository);

  final IHabitsRepository _habitsRepository;

  @override
  Future<void> getRawFuture(Habit params) async {
    return _habitsRepository.deleteHabit(params);
  }
}
