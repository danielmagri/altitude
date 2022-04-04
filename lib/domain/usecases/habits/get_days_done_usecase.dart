import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDaysDoneUsecase extends BaseUsecase<GetDaysDoneParams, List<DayDone>> {
  GetDaysDoneUsecase(this._habitsRepository);

  final IHabitsRepository _habitsRepository;

  @override
  Future<List<DayDone>> getRawFuture(GetDaysDoneParams params) async {
    return _habitsRepository.getDaysDone(params.id, params.start, params.end);
  }
}

class GetDaysDoneParams {
  GetDaysDoneParams({
    required this.end,
    this.id,
    this.start,
  });

  final String? id;
  final DateTime? start;
  final DateTime end;
}
