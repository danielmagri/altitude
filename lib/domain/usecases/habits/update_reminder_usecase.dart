import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateReminderUsecase extends BaseUsecase<UpdateReminderParams, void> {
  final IHabitsRepository _habitsRepository;
  final IUserRepository _userRepository;

  UpdateReminderUsecase(this._habitsRepository, this._userRepository);

  @override
  Future<void> getRawFuture(UpdateReminderParams params) async {
    int reminderCounter = await _userRepository.getReminderCounter();

    return _habitsRepository.updateReminder(
        params.reminderId, params.habit, reminderCounter);
  }
}

class UpdateReminderParams {
  final int? reminderId;
  final Habit habit;

  UpdateReminderParams({this.reminderId, required this.habit});
}
