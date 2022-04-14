import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/constant/constants.dart';
import 'package:altitude/data/repository/competitions_repository.dart';
import 'package:altitude/data/repository/notifications_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:altitude/domain/models/competition_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class InviteCompetitorUsecase
    extends BaseUsecase<InviteCompetitorParams, void> {
  InviteCompetitorUsecase(
    this._competitionsRepository,
    this._userRepository,
    this._notificationsRepository,
  );

  final ICompetitionsRepository _competitionsRepository;
  final IUserRepository _userRepository;
  final INotificationsRepository _notificationsRepository;

  @override
  Future<void> getRawFuture(InviteCompetitorParams params) async {
    Competition competition = await _competitionsRepository
        .getCompetition(params.competitionId ?? '');

    if (competition.competitors.length < maxCompetitors) {
      await _competitionsRepository.inviteCompetitor(
        params.competitionId ?? '',
        params.competitorId,
      );

      final userName = (await _userRepository.getUserData(false)).name;

      for (String? token in params.fcmTokens) {
        await _notificationsRepository.sendInviteCompetitionNotification(
          userName,
          competition.title,
          token ?? '',
        );
      }
    } else {
      throw 'Máximo de competidores atingido.';
    }
  }
}

class InviteCompetitorParams {
  InviteCompetitorParams({
    required this.competitorId,
    required this.fcmTokens,
    this.competitionId,
  });

  final String? competitionId;
  final List<String> competitorId;
  final List<String> fcmTokens;
}
