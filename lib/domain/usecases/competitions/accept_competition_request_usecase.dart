import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/domain/usecases/competitions/get_competition_usecase.dart';
import 'package:altitude/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_fire_functions.dart';

class AcceptCompetitionRequestUsecase
    extends BaseUsecase<AcceptCompetitionRequestParams, void> {
  final Memory _memory;
  final IFireDatabase _fireDatabase;
  final IFireFunctions _fireFunctions;
  final GetCompetitionUsecase _getCompetitionUsecase;
  final GetUserDataUsecase _getUserDataUsecase;

  AcceptCompetitionRequestUsecase(
      this._memory,
      this._fireDatabase,
      this._fireFunctions,
      this._getCompetitionUsecase,
      this._getUserDataUsecase);

  @override
  Future<void> getRawFuture(AcceptCompetitionRequestParams params) async {
    Competition competition = await _getCompetitionUsecase
        .call(params.competitionId)
        .resultComplete((data) => data, (error) => throw error);
    if (competition.competitors!.length < MAX_COMPETITORS) {
      await _fireDatabase.acceptCompetitionRequest(
          params.competitionId, params.competitor);

      String userName = (await _getUserDataUsecase
                  .call(false)
                  .resultComplete((data) => data, (error) => null))
              ?.name ??
          '';

      for (Competitor friend in competition.competitors!) {
        await _fireFunctions.sendNotification("Novo competidor",
            "$userName entrou em  ${competition.title}", friend.fcmToken ?? '');
      }

      competition.competitors!.add(params.competitor);
      _memory.competitions.add(competition);
    } else {
      throw "Máximo de competidores atingido.";
    }
  }
}

class AcceptCompetitionRequestParams {
  final String competitionId;
  final Competition competition;
  final Competitor competitor;

  AcceptCompetitionRequestParams(
      {required this.competitionId,
      required this.competition,
      required this.competitor});
}
