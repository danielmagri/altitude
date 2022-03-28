import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';

class GetHabitUsecase extends BaseUsecase<String, Habit> {
  final Memory _memory;
  final IFireDatabase _fireDatabase;

  GetHabitUsecase(this._memory, this._fireDatabase);

  @override
  Future<Habit> getRawFuture(String params) async {
    var data = await _fireDatabase.getHabit(params);

    int index = _memory.habits.indexWhere((e) => e.id == params);
    if (index == -1) {
      _memory.habits.add(data);
    } else {
      _memory.habits[index] = data;
    }
    return data;
  }
}
