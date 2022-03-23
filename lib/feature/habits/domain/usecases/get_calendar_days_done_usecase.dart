import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GetCalendarDaysDoneUsecase
    extends BaseUsecase<GetCalendarDaysDoneParams, Map<DateTime?, List>> {
  final IFireDatabase _fireDatabase;

  GetCalendarDaysDoneUsecase(this._fireDatabase);

  @override
  Future<Map<DateTime?, List>> getRawFuture(
      GetCalendarDaysDoneParams params) async {
    DateTime startDate = params.start.subtract(const Duration(days: 1));
    DateTime endDate = params.end.add(const Duration(days: 1));
    var data = await _fireDatabase.getDaysDone(params.id, startDate, endDate);
    Map<DateTime?, List> map = Map();
    bool before = false;
    bool after = false;

    for (int i = 0; i < data.length; i++) {
      if (i - 1 >= 0 &&
          data[i].date!.difference(data[i - 1].date!) ==
              const Duration(days: 1)) {
        before = true;
      } else {
        before = false;
      }

      if (i + 1 < data.length &&
          data[i + 1].date!.difference(data[i].date!) ==
              const Duration(days: 1)) {
        after = true;
      } else {
        after = false;
      }

      map.putIfAbsent(data[i].date, () => [before, after]);
    }
    return map;
  }
}

class GetCalendarDaysDoneParams {
  final String id;
  final DateTime start;
  final DateTime end;

  GetCalendarDaysDoneParams(
      {required this.id, required this.start, required this.end});
}
