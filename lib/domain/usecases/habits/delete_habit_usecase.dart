import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/infra/services/Memory.dart';
import 'package:altitude/infra/interface/i_fire_analytics.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:altitude/infra/interface/i_local_notification.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteHabitUsecase extends BaseUsecase<Habit, void> {
  final Memory _memory;
  final IFireDatabase _fireDatabase;
  final ILocalNotification _localNotification;
  final IFireAnalytics _fireAnalytics;

  DeleteHabitUsecase(this._memory, this._fireDatabase, this._localNotification,
      this._fireAnalytics);

  @override
  Future<void> getRawFuture(Habit params) async {
    if (params.reminder != null) {
      _localNotification.removeNotification(params.reminder!.id);
    }
    _fireAnalytics.sendRemoveHabit(params.habit);

    await _fireDatabase.deleteHabit(params.id);

    int index = _memory.habits.indexWhere((e) => e.id == params.id);
    if (index != -1) {
      _memory.habits.removeAt(index);
    }
  }
}
