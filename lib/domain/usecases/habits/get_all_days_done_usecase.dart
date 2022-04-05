import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:altitude/domain/models/day_done_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllDaysDoneUsecase extends BaseUsecase<List<Habit>, List<DayDone>> {
  GetAllDaysDoneUsecase(this._habitsRepository);

  final IHabitsRepository _habitsRepository;

  @override
  Future<List<DayDone>> getRawFuture(List<Habit> params) async {
    return _habitsRepository.getAllDaysDone(params);
  }
}
