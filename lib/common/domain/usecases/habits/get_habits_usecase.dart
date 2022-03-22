
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@usecase
@Injectable()
class GetHabitsUsecase extends BaseUsecase<bool, List<Habit>> {

  final Memory _memory;
  final IFireDatabase _fireDatabase;

  GetHabitsUsecase(this._memory, this._fireDatabase);


  @override
  Future<List<Habit>> getRawFuture(bool params) async {
     if (_memory.habits.isEmpty) {
          var data = await _fireDatabase.getHabits();
          if (!params) {
            _memory.habits = data;
          }
          return data;
        } else {
          return _memory.habits;
        }
  }

}