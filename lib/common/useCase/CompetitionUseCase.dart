import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/controllers/ScoreControl.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/base/BaseUseCase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/model/Result.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_fire_functions.dart';
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@usecase
@Injectable()
class CompetitionUseCase extends BaseUseCase {
  static CompetitionUseCase get getI => GetIt.I.get<CompetitionUseCase>();

  final Memory _memory;
  final PersonUseCase _personUseCase;
  final IFireDatabase _fireDatabase;
  final IFireMessaging _fireMessaging;
  final IFireFunctions _fireFunctions;
  final IFireAnalytics _fireAnalytics;

  CompetitionUseCase(this._memory, this._personUseCase, this._fireDatabase, this._fireMessaging, this._fireFunctions,
      this._fireAnalytics);

  bool get pendingCompetitionsStatus => SharedPref.instance.pendingCompetition;
  set pendingCompetitionsStatus(bool value) => SharedPref.instance.pendingCompetition = value;

  Future<Result<List<Competition>>> getCompetitions({bool fromServer = false}) => safeCall(() async {
        if (_memory.competitions.isEmpty || fromServer) {
          List<Competition> list = await _fireDatabase.getCompetitions();
          _memory.competitions = list;
          return list;
        } else {
          return _memory.competitions;
        }
      });

  Future<Result<Competition>> getCompetition(String id) => safeCall(() async {
        Competition competition = await _fireDatabase.getCompetition(id);
        int index = _memory.competitions.indexWhere((element) => element.id == id);
        if (index != -1) {
          _memory.competitions[index] = competition;
        }
        return competition;
      });

  Future<Result<List<Competition>>> getPendingCompetitions() => safeCall(() async {
        List<Competition> list = await _fireDatabase.getPendingCompetitions();
        pendingCompetitionsStatus = list.isNotEmpty;
        return list;
      });

  Future<Result<Competition>> createCompetition(
          String title, Habit habit, List<String> invitations, List<String> invitationsToken) =>
      safeCall(() async {
        DateTime date = DateTime.now().today;

        Competitor competitor = Competitor(
            uid: _personUseCase.uid,
            name: _personUseCase.name,
            fcmToken: await _fireMessaging.getToken,
            habitId: habit.id,
            color: habit.colorCode,
            score: await _fireDatabase.hasDoneAtDay(habit.id, date) ? ScoreControl.DAY_DONE_POINT : 0,
            you: true);

        Competition competition = await _fireDatabase.createCompetition(
            Competition(title: title, initialDate: date, competitors: [competitor], invitations: invitations));

        for (String token in invitationsToken) {
          await _fireFunctions.sendNotification(
              "Convite de competição", "${_personUseCase.name} te convidou a participar do $title", token);
        }

        _fireAnalytics.sendCreateCompetition(title, habit.habit, invitations.length);

        _memory.competitions.add(competition);

        return competition;
      });

  Future<Result> updateCompetition(String id, String title) => safeCall(() async {
        await _fireDatabase.updateCompetition(id, title);
        int index = _memory.competitions.indexWhere((element) => element.id == id);
        if (index != -1) {
          _memory.competitions[index].title = title;
        }
      });

  Future<Result> updateCompetitor(String competitionId, String habitId) => safeCall(() async {
        await _fireDatabase.updateCompetitor(competitionId, habitId);
      });

  Future<Result> removeCompetitor(Competition competition) => safeCall(() async {
        await _fireDatabase.removeCompetitor(competition.id, _personUseCase.uid, competition.competitors.length == 1);
        _memory.competitions.removeWhere((element) => element.id == competition.id);
      });

  Future<Result> inviteCompetitor(String competitionId, List<String> competitorId, List<String> fcmTokens) =>
      safeCall(() async {
        Competition competition = (await getCompetition(competitionId)).absoluteResult();
        if (competition.competitors.length < MAX_COMPETITORS) {
          await _fireDatabase.inviteCompetitor(competitionId, competitorId);

          for (String token in fcmTokens) {
            await _fireFunctions.sendNotification("Convite de competição",
                "${_personUseCase.name} te convidou a participar do ${competition.title}", token);
          }
        } else {
          throw "Máximo de competidores atingido.";
        }
      });

  Future<Result> acceptCompetitionRequest(String competitionId, Competition competition, Competitor competitor) =>
      safeCall(() async {
        Competition competition = (await getCompetition(competitionId)).absoluteResult();
        if (competition.competitors.length < MAX_COMPETITORS) {
          await _fireDatabase.acceptCompetitionRequest(competitionId, competitor);
          _memory.competitions.add(competition);

          for (Competitor friend in competition.competitors) {
            await _fireFunctions.sendNotification(
                "Novo competidor", "${_personUseCase.name} entrou em  ${competition.title}", friend.fcmToken);
          }
        } else {
          throw "Máximo de competidores atingido.";
        }
      });

  Future<Result> declineCompetitionRequest(String id) => safeCall(() async {
        return await _fireDatabase.declineCompetitionRequest(id);
      });

  Future<bool> hasCompetitionByHabit(String habitId) async {
    try {
      return (await getCompetitions()).absoluteResult().where((e) => e.getMyCompetitor().habitId == habitId).isNotEmpty;
    } catch (e) {
      return Future.value(false);
    }
  }

  Future<bool> maximumNumberReached() async {
    try {
      int length = (await getCompetitions()).absoluteResult().length;

      return length >= MAX_COMPETITIONS;
    } catch (e) {
      return Future.value(true);
    }
  }

  Future<bool> maximumNumberReachedByHabit(String habitId) async {
    try {
      int length =
          (await getCompetitions()).absoluteResult().where((e) => e.getMyCompetitor().habitId == habitId).length;

      return length >= MAX_HABIT_COMPETITIONS;
    } catch (e) {
      return Future.value(true);
    }
  }
}
