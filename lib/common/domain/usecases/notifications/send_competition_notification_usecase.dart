import 'package:altitude/common/domain/model/params/send_competition_notification_params.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/services/interfaces/i_fire_functions.dart';
import 'package:injectable/injectable.dart';

@usecase
@Injectable()
class SendCompetitionNotificationUsecase
    extends BaseUsecase<SendCompetitionNotificationParams, void> {
  final PersonUseCase _personUseCase;
  final IFireFunctions _fireFunctions;

  SendCompetitionNotificationUsecase(this._personUseCase, this._fireFunctions);

  @override
  Future<void> getRawFuture(SendCompetitionNotificationParams params) async {
    final String? name = _personUseCase.name;

    params.competitions.forEach((competition) {
      int? oldScore = competition.competitors!.firstWhere((e) => e.you!).score;

      competition.competitors!.forEach((competitor) {
        if (!competitor.you!) {
          if (competitor.score >= oldScore &&
              (oldScore + params.earnedScore) > competitor.score) {
            _fireFunctions.sendNotification(
                "Tem alguém comendo poeira!",
                "$name acabou de te ultrapassar em ${competition.title}",
                competitor.fcmToken);
          } else if (params.earnedScore >= 4 &&
              (oldScore + params.earnedScore) <= competitor.score) {
            _fireFunctions.sendNotification(
                "Cuidado!",
                "$name está se aproximando rapidamente em ${competition.title}",
                competitor.fcmToken);
          } else if (params.earnedScore >= 4 && oldScore > competitor.score) {
            _fireFunctions.sendNotification(
                "Sempre é hora de reagir!",
                "$name está se distanciando cada vez mais de você em ${competition.title}",
                competitor.fcmToken);
          }
        }
      });
    });

    return null;
  }
}
