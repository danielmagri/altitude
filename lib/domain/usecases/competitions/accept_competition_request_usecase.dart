import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/constant/constants.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/data/repository/notifications_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:altitude/domain/models/competition_entity.dart';
import 'package:altitude/domain/models/competitor_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class AcceptCompetitionRequestUsecase
    extends BaseUsecase<AcceptCompetitionRequestParams, void> {
  AcceptCompetitionRequestUsecase(
    this._competitionsRepository,
    this._notificationsRepository,
    this._userRepository,
  );

  final ICompetitionsRepository _competitionsRepository;
  final INotificationsRepository _notificationsRepository;
  final IUserRepository _userRepository;

  @override
  Future<void> getRawFuture(AcceptCompetitionRequestParams params) async {
    Competition competition =
        await _competitionsRepository.getCompetition(params.competitionId);

    if (competition.competitors.length < MAX_COMPETITORS) {
      await _competitionsRepository.acceptCompetitionRequest(
        params.competitionId,
        params.competitor,
        competition,
      );

      String userName = (await _userRepository.getUserData(false)).name ?? '';

      for (Competitor friend in competition.competitors) {
        await _notificationsRepository.sendNewCompetitorNotification(
          userName,
          competition.title,
          friend.fcmToken,
        );
      }
    } else {
      throw 'Máximo de competidores atingido.';
    }
  }
}

class AcceptCompetitionRequestParams {
  AcceptCompetitionRequestParams({
    required this.competitionId,
    required this.competition,
    required this.competitor,
  });

  final String competitionId;
  final Competition competition;
  final Competitor competitor;
}
