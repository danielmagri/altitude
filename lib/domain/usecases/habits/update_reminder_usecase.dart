import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/core/model/no_params.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_local_notification.dart';
import 'package:altitude/domain/usecases/habits/get_reminder_counter_usecase.dart';

class UpdateReminderUsecase extends BaseUsecase<UpdateReminderParams, void> {
  final Memory _memory;
  final ILocalNotification _localNotification;
  final IFireDatabase _fireDatabase;
  final GetReminderCounterUsecase _getReminderCounterUsecase;

  UpdateReminderUsecase(this._memory, this._localNotification,
      this._fireDatabase, this._getReminderCounterUsecase);

  @override
  Future<void> getRawFuture(UpdateReminderParams params) async {
    if (params.reminderId != null) {
      await _localNotification.removeNotification(params.reminderId);
    }

    if (params.habit.reminder != null) {
      int? reminderCounter;
      if (params.habit.reminder!.id == null) {
        reminderCounter = await _getReminderCounterUsecase
            .call(NoParams())
            .resultComplete((data) => data, (error) => null);
        params.habit.reminder!.id = reminderCounter;
      }

      await _fireDatabase.updateReminder(
          params.habit.id, reminderCounter, params.habit.reminder);
      int index = _memory.habits.indexWhere((e) => e.id == params.habit.id);
      if (index != -1) {
        _memory.habits[index] = params.habit;
      }
      await _localNotification.addNotification(params.habit);
    } else {
      await _fireDatabase.updateReminder(params.habit.id, null, null);
      int index = _memory.habits.indexWhere((e) => e.id == params.habit.id);
      if (index != -1) {
        _memory.habits[index] = params.habit;
      }
    }
  }
}

class UpdateReminderParams {
  final int? reminderId;
  final Habit habit;

  UpdateReminderParams({this.reminderId, required this.habit});
}
