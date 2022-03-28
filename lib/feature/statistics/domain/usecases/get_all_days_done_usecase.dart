import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';

class GetAllDaysDoneUsecase extends BaseUsecase<List<Habit>, List<DayDone>> {
  final IFireDatabase _fireDatabase;

  GetAllDaysDoneUsecase(this._fireDatabase);

  @override
  Future<List<DayDone>> getRawFuture(List<Habit> params) async {
    List<DayDone> list = [];

    for (Habit habit in params) {
      list.addAll((await _fireDatabase.getAllDaysDone(habit.id))
          .map((e) => DayDone(date: e.date, habitId: habit.id)));
    }

    return list;
  }
}
