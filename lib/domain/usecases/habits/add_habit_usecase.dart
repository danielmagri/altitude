import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:altitude/domain/models/frequency_entity.dart';
import 'package:altitude/domain/models/habit_entity.dart';
import 'package:altitude/domain/models/reminder_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddHabitUsecase extends BaseUsecase<AddHabitParams, Habit> {
  AddHabitUsecase(this._habitsRepository, this._userRepository);

  final IHabitsRepository _habitsRepository;
  final IUserRepository _userRepository;

  @override
  Future<Habit> getRawFuture(AddHabitParams params) async {
    int? reminderCounter;
    if (params.reminder != null) {
      reminderCounter = await _userRepository.getReminderCounter();
      params.reminder!.id = reminderCounter;
    }
    return _habitsRepository.addHabit(
      params.habit,
      params.colorCode,
      params.frequency,
      params.initialDate,
      params.reminder,
      reminderCounter,
    );
  }
}

class AddHabitParams {
  AddHabitParams(
    this.habit,
    this.colorCode,
    this.frequency,
    this.initialDate,
    this.reminder,
  );

  final String habit;
  final int colorCode;
  final Frequency frequency;
  final DateTime initialDate;
  final Reminder? reminder;
}
