import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCalendarDaysDoneUsecase
    extends BaseUsecase<GetCalendarDaysDoneParams, Map<DateTime, List<bool>>> {
  final IHabitsRepository _habitsRepository;

  GetCalendarDaysDoneUsecase(this._habitsRepository);

  @override
  Future<Map<DateTime, List<bool>>> getRawFuture(
      GetCalendarDaysDoneParams params) async {
    return _habitsRepository.getCalendarDaysDone(
        params.id, params.month, params.year);
  }
}

class GetCalendarDaysDoneParams {
  final String id;
  final int month;
  final int year;

  GetCalendarDaysDoneParams(
      {required this.id, required this.month, required this.year});
}
