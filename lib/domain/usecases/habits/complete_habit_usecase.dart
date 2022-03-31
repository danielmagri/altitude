import 'package:altitude/data/repository/habits_repository.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/notifications_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:injectable/injectable.dart';

@injectable
class CompleteHabitUsecase extends BaseUsecase<CompleteParams, void> {
  final IHabitsRepository _habitsRepository;
  final ICompetitionsRepository _competitionsRepository;
  final INotificationsRepository _notificationsRepository;
  final IUserRepository _userRepository;

  CompleteHabitUsecase(
    this._habitsRepository,
    this._competitionsRepository,
    this._notificationsRepository,
    this._userRepository,
  );

  @override
  Future<void> getRawFuture(CompleteParams params) async {
    List<Competition> competitions =
        await _competitionsRepository.getCompetitions(false).then((list) {
      return list
          .where((e) =>
              e.getMyCompetitor().habitId == params.habitId &&
              e.initialDate!.isBeforeOrSameDay(params.date))
          .toList();
    });

    Person person = await _userRepository.getUserData(false);

    int earnedScore = await _habitsRepository.completeHabit(
        params.habitId,
        person.score ?? 0,
        params.date,
        params.isAdd,
        params.daysDone,
        competitions);

    _notificationsRepository.sendCompetitionNotification(
        person.name ?? '', earnedScore, competitions);
  }
}

class CompleteParams {
  final String habitId;
  final DateTime date;
  final bool isAdd;
  final List<DateTime>? daysDone;

  CompleteParams({
    required this.habitId,
    required this.date,
    this.isAdd = true,
    this.daysDone,
  });
}
