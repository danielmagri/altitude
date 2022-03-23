import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/domain/usecases/competitions/get_competition_usecase.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/common/shared_pref/shared_pref.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/base/BaseUseCase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/model/result.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_fire_functions.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@deprecated
@usecase
@Injectable()
class CompetitionUseCase extends BaseUseCase {
  static CompetitionUseCase get getI => GetIt.I.get<CompetitionUseCase>();

  final Memory _memory;
  final PersonUseCase _personUseCase;
  final IFireDatabase _fireDatabase;
  final IFireFunctions _fireFunctions;
  final GetCompetitionUsecase _getCompetitionUsecase;

  CompetitionUseCase(this._memory, this._personUseCase, this._fireDatabase,
      this._fireFunctions, this._getCompetitionUsecase);

  bool get pendingCompetitionsStatus => SharedPref.instance.pendingCompetition;
  set pendingCompetitionsStatus(bool value) =>
      SharedPref.instance.pendingCompetition = value;

  Future<Result> updateCompetitor(String competitionId, String habitId) =>
      safeCall(() async {
        await _fireDatabase.updateCompetitor(competitionId, habitId);
      });

  Future<Result> inviteCompetitor(String? competitionId,
          List<String?> competitorId, List<String?> fcmTokens) =>
      safeCall(() async {
        Competition competition =
            (await _getCompetitionUsecase(competitionId)).absoluteResult();
        if (competition.competitors!.length < MAX_COMPETITORS) {
          await _fireDatabase.inviteCompetitor(competitionId, competitorId);

          for (String? token in fcmTokens) {
            await _fireFunctions.sendNotification(
                "Convite de competição",
                "${_personUseCase.name} te convidou a participar do ${competition.title}",
                token);
          }
        } else {
          throw "Máximo de competidores atingido.";
        }
      });

  Future<Result> acceptCompetitionRequest(String? competitionId,
          Competition competition, Competitor competitor) =>
      safeCall(() async {
        Competition competition =
            (await _getCompetitionUsecase(competitionId)).absoluteResult();
        if (competition.competitors!.length < MAX_COMPETITORS) {
          await _fireDatabase.acceptCompetitionRequest(
              competitionId, competitor);

          for (Competitor friend in competition.competitors!) {
            await _fireFunctions.sendNotification(
                "Novo competidor",
                "${_personUseCase.name} entrou em  ${competition.title}",
                friend.fcmToken);
          }

          competition.competitors!.add(competitor);
          _memory.competitions.add(competition);
        } else {
          throw "Máximo de competidores atingido.";
        }
      });
}
