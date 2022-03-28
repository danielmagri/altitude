import 'package:altitude/common/constant/app_colors.dart';
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/core/model/no_params.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_local_notification.dart';
import 'package:altitude/common/domain/usecases/habits/get_reminder_counter_usecase.dart';

class AddHabitUsecase extends BaseUsecase<Habit, Habit> {
  final IFireDatabase _fireDatabase;
  final ILocalNotification _localNotification;
  final IFireAnalytics _fireAnalytics;
  final Memory _memory;
  final GetReminderCounterUsecase _getReminderCounterUsecase;

  AddHabitUsecase(this._fireDatabase, this._fireAnalytics, this._memory,
      this._localNotification, this._getReminderCounterUsecase);

  @override
  Future<Habit> getRawFuture(Habit params) async {
    int? reminderCounter;
    if (params.reminder != null) {
      reminderCounter = await _getReminderCounterUsecase.call(NoParams())
          .resultComplete((data) => data, (error) => null);
      params.reminder!.id = reminderCounter;
    }
    var data = await _fireDatabase.addHabit(params, reminderCounter);
    _fireAnalytics.sendNewHabit(
        params.habit,
        AppColors.habitsColorName[params.colorCode!],
        params.frequency.runtimeType == DayWeek
            ? "Diariamente"
            : "Semanalmente",
        params.frequency!.daysCount(),
        params.reminder != null ? "Sim" : "Não");

    _memory.habits.add(data);

    if (params.reminder != null) {
      await _localNotification.addNotification(params);
    }

    return data;
  }
}
