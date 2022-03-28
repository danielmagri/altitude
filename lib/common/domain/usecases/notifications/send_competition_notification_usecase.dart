import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/core/services/interfaces/i_fire_functions.dart';

class SendCompetitionNotificationUsecase
    extends BaseUsecase<SendCompetitionNotificationParams, void> {
  final GetUserDataUsecase _getUserDataUsecase;
  final IFireFunctions _fireFunctions;

  SendCompetitionNotificationUsecase(
      this._getUserDataUsecase, this._fireFunctions);

  @override
  Future<void> getRawFuture(SendCompetitionNotificationParams params) async {
    final String? name = (await _getUserDataUsecase
            .call(false)
            .resultComplete((data) => data, (error) => null))
        ?.name;

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

class SendCompetitionNotificationParams {
  final int earnedScore;
  final List<Competition> competitions;

  SendCompetitionNotificationParams(
      {required this.earnedScore, required this.competitions});
}
