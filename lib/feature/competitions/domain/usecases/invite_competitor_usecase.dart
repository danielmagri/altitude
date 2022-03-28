import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/domain/usecases/competitions/get_competition_usecase.dart';
import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_fire_functions.dart';

class InviteCompetitorUsecase
    extends BaseUsecase<InviteCompetitorParams, void> {
  final GetCompetitionUsecase _getCompetitionUsecase;
  final GetUserDataUsecase _getUserDataUsecase;
  final IFireDatabase _fireDatabase;
  final IFireFunctions _fireFunctions;

  InviteCompetitorUsecase(this._getCompetitionUsecase, this._getUserDataUsecase,
      this._fireDatabase, this._fireFunctions);

  @override
  Future<void> getRawFuture(InviteCompetitorParams params) async {
    Competition competition = await _getCompetitionUsecase(params.competitionId)
        .resultComplete((data) => data, (error) => throw error);
    if (competition.competitors!.length < MAX_COMPETITORS) {
      await _fireDatabase.inviteCompetitor(
          params.competitionId, params.competitorId);

      final userName = (await _getUserDataUsecase
                  .call(false)
                  .resultComplete((data) => data, (error) => null))
              ?.name ??
          "";
      for (String? token in params.fcmTokens) {
        await _fireFunctions.sendNotification(
            "Convite de competição",
            "$userName te convidou a participar do ${competition.title}",
            token);
      }
    } else {
      throw "Máximo de competidores atingido.";
    }
  }
}

class InviteCompetitorParams {
  final String? competitionId;
  final List<String?> competitorId;
  final List<String?> fcmTokens;

  InviteCompetitorParams(
      {this.competitionId,
      required this.competitorId,
      required this.fcmTokens});
}
