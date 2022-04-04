import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetHabitsUsecase extends BaseUsecase<bool, List<Habit>> {
  GetHabitsUsecase(this._habitsRepository);

  final IHabitsRepository _habitsRepository;

  @override
  Future<List<Habit>> getRawFuture(bool params) {
    return _habitsRepository.getHabits(params);
  }
}
