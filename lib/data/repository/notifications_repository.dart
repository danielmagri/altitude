import 'package:altitude/domain/models/competition_entity.dart';
import 'package:altitude/infra/interface/i_fire_functions.dart';
import 'package:injectable/injectable.dart';

abstract class INotificationsRepository {
  Future<void> sendCompetitionNotification(
    String name,
    int earnedScore,
    List<Competition> competitions,
  );
  Future<void> sendInviteCompetitionNotification(
    String userName,
    String competitionTitle,
    String friendToken,
  );
  Future<void> sendNewCompetitorNotification(
    String userName,
    String competitionTitle,
    String friendToken,
  );
  Future<void> sendInviteFriendNotification(
    String userName,
    String friendToken,
  );
  Future<void> acceptFriendNotification(String userName, String friendToken);
}

@Injectable(as: INotificationsRepository)
class NotificationsRepository extends INotificationsRepository {
  NotificationsRepository(this._fireFunctions);

  final IFireFunctions _fireFunctions;

  @override
  Future<void> sendCompetitionNotification(
    String name,
    int earnedScore,
    List<Competition> competitions,
  ) async {
    competitions.forEach((competition) {
      int? oldScore = competition.competitors.firstWhere((e) => e.you!).score;

      competition.competitors.forEach((competitor) {
        if (!competitor.you!) {
          if (competitor.score >= oldScore &&
              (oldScore + earnedScore) > competitor.score) {
            _fireFunctions.sendNotification(
              'Tem alguém comendo poeira!',
              '$name acabou de te ultrapassar em ${competition.title}',
              competitor.fcmToken ?? '',
            );
          } else if (earnedScore >= 4 &&
              (oldScore + earnedScore) <= competitor.score) {
            _fireFunctions.sendNotification(
              'Cuidado!',
              '$name está se aproximando rapidamente em ${competition.title}',
              competitor.fcmToken ?? '',
            );
          } else if (earnedScore >= 4 && oldScore > competitor.score) {
            _fireFunctions.sendNotification(
              'Sempre é hora de reagir!',
              '$name está se distanciando cada vez mais de você em ${competition.title}',
              competitor.fcmToken ?? '',
            );
          }
        }
      });
    });
  }

  @override
  Future<void> sendInviteCompetitionNotification(
    String userName,
    String competitionTitle,
    String friendToken,
  ) async {
    await _fireFunctions.sendNotification(
      'Convite de competição',
      '$userName te convidou a participar do $competitionTitle',
      friendToken,
    );
  }

  @override
  Future<void> sendNewCompetitorNotification(
    String userName,
    String competitionTitle,
    String friendToken,
  ) async {
    await _fireFunctions.sendNotification(
      'Novo competidor',
      '$userName entrou em  $competitionTitle',
      friendToken,
    );
  }

  @override
  Future<void> sendInviteFriendNotification(
    String userName,
    String friendToken,
  ) async {
    await _fireFunctions.sendNotification(
      'Pedido de amizade',
      '$userName quer ser seu amigo.',
      friendToken,
    );
  }

  @override
  Future<void> acceptFriendNotification(
    String userName,
    String friendToken,
  ) async {
    await _fireFunctions.sendNotification(
      'Pedido de amizade',
      '$userName aceitou seu pedido.',
      friendToken,
    );
  }
}
