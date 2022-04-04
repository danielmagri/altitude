import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteHabitUsecase extends BaseUsecase<Habit, void> {
  final IHabitsRepository _habitsRepository;

  DeleteHabitUsecase(this._habitsRepository);

  @override
  Future<void> getRawFuture(Habit params) async {
    return _habitsRepository.deleteHabit(params);
  }
}
