import 'package:altitude/common/model/DayDone.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class TransferHabitUsecase extends BaseUsecase<TransferHabitParams, void> {
  final IHabitsRepository _habitsRepository;
  final IUserRepository _userRepository;

  TransferHabitUsecase(this._habitsRepository, this._userRepository);

  @override
  Future<void> getRawFuture(TransferHabitParams params) async {
    int? reminderCounter;
    if (params.habit.reminder != null) {
      reminderCounter = await _userRepository.getReminderCounter();
      params.habit.reminder!.id = reminderCounter;
    }

    await _habitsRepository.transferHabit(
      params.habit,
      params.competitionsId,
      params.daysDone,
      reminderCounter,
    );
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
