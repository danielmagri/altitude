import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/data/repository/habits_repository.dart';
import 'package:altitude/data/repository/notifications_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:altitude/infra/interface/i_score_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateCompetitionUsecase
    extends BaseUsecase<CreateCompetitionParams, Competition> {
  CreateCompetitionUsecase(
    this._competitionsRepository,
    this._notificationsRepository,
    this._userRepository,
    this._habitsRepository,
  );

  final ICompetitionsRepository _competitionsRepository;
  final INotificationsRepository _notificationsRepository;
  final IUserRepository _userRepository;
  final IHabitsRepository _habitsRepository;

  @override
  Future<Competition> getRawFuture(CreateCompetitionParams params) async {
    DateTime date = DateTime.now().onlyDate;

    final person = await _userRepository.getUserData(false);

    Competitor competitor = Competitor(
      uid: person.uid,
      name: person.name,
      fcmToken: person.fcmToken,
      habitId: params.habit.id,
      color: params.habit.colorCode,
      score: await _habitsRepository.hasDoneAtDay(params.habit.id ?? '', date)
          ? IScoreService.DAY_DONE_POINT
          : 0,
      you: true,
    );

    final competition = _competitionsRepository.createCompetition(
      Competition(
        title: params.title,
        initialDate: date,
        competitors: [competitor],
        invitations: params.invitations,
      ),
      params.habit.habit ?? '',
    );

    for (String token in params.invitationsToken) {
      await _notificationsRepository.sendInviteCompetitionNotification(
        person.name ?? '',
        params.title,
        token,
      );
    }

    return competition;
  }
}

class CreateCompetitionParams {
  CreateCompetitionParams({
    required this.title,
    required this.habit,
    required this.invitations,
    required this.invitationsToken,
  });

  final String title;
  final Habit habit;
  final List<String> invitations;
  final List<String> invitationsToken;
}
