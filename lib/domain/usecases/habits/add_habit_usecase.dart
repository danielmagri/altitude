import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddHabitUsecase extends BaseUsecase<Habit, Habit> {
  AddHabitUsecase(this._habitsRepository, this._userRepository);

  final IHabitsRepository _habitsRepository;
  final IUserRepository _userRepository;

  @override
  Future<Habit> getRawFuture(Habit params) async {
    int? reminderCounter;
    if (params.reminder != null) {
      reminderCounter = await _userRepository.getReminderCounter();
      params.reminder!.id = reminderCounter;
    }
    return _habitsRepository.addHabit(params, reminderCounter);
  }
}
