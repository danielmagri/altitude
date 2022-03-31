import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/domain/usecases/habits/get_reminder_counter_usecase.dart';
import 'package:altitude/core/model/no_params.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_local_notification.dart';
import 'package:injectable/injectable.dart';

@injectable
class TransferHabitUsecase extends BaseUsecase<TransferHabitParams, void> {
  final IFireDatabase _fireDatabase;
  final ILocalNotification _localNotification;
  final GetReminderCounterUsecase _getReminderCounterUsecase;

  TransferHabitUsecase(this._fireDatabase, this._localNotification,
      this._getReminderCounterUsecase);

  @override
  Future<void> getRawFuture(TransferHabitParams params) async {
    int? reminderCounter;
    if (params.habit.reminder != null) {
      reminderCounter = await _getReminderCounterUsecase
          .call(NoParams())
          .resultComplete((data) => data, (error) => null);
      params.habit.reminder!.id = reminderCounter;
    }

    if (params.habit.reminder != null) {
      await _localNotification.addNotification(params.habit);
    }

    if (params.daysDone.length > 450) {
      String id = await _fireDatabase.transferHabit(
          params.habit,
          reminderCounter,
          params.competitionsId,
          params.daysDone.sublist(0, 450));
      await _fireDatabase.transferDayDonePlus(
          id, params.daysDone.sublist(450, params.daysDone.length));
    } else {
      await _fireDatabase.transferHabit(params.habit, reminderCounter,
          params.competitionsId, params.daysDone);
    }
  }
}

class TransferHabitParams {
  final Habit habit;
  final List<String?> competitionsId;
  final List<DayDone> daysDone;

  TransferHabitParams(
      {required this.habit,
      required this.competitionsId,
      required this.daysDone});
}
