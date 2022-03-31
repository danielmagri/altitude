import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';

class GetCalendarDaysDoneUsecase
    extends BaseUsecase<GetCalendarDaysDoneParams, Map<DateTime, List<bool>>> {
  final IFireDatabase _fireDatabase;

  GetCalendarDaysDoneUsecase(this._fireDatabase);

  @override
  Future<Map<DateTime, List<bool>>> getRawFuture(
      GetCalendarDaysDoneParams params) async {
    final firstDayMonth = DateTime.utc(params.year, params.month, 1);
    final lastDayMonth = DateTime.utc(params.year, params.month + 1, 1)
        .subtract(Duration(days: 1));

    DateTime startDate = firstDayMonth.subtract(Duration(
        days: firstDayMonth.weekday == 7 ? 1 : firstDayMonth.weekday + 1));
    DateTime endDate = lastDayMonth.add(Duration(
        days: firstDayMonth.weekday == 7 ? 7 : 7 - firstDayMonth.weekday));
    var data = await _fireDatabase.getDaysDone(params.id, startDate, endDate);
    Map<DateTime, List<bool>> map = Map();
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

      map.putIfAbsent(data[i].date!, () => [before, after]);
    }
    return map;
  }
}

class GetCalendarDaysDoneParams {
  final String id;
  final int month;
  final int year;

  GetCalendarDaysDoneParams(
      {required this.id, required this.month, required this.year});
}
