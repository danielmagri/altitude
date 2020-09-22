import 'package:altitude/common/constant/Constants.dart';
import 'package:altitude/common/controllers/ScoreControl.dart';
import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/base/BaseUseCase.dart';
import 'package:altitude/core/model/Result.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/core/services/FireDatabase.dart';
import 'package:altitude/core/services/FireMenssaging.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/extensions/DateTimeExtension.dart';
import 'package:get_it/get_it.dart';

class CompetitionUseCase extends BaseUseCase {
  static CompetitionUseCase get getInstance => GetIt.I.get<CompetitionUseCase>();

  final Memory _memory = Memory.getInstance;
  final PersonUseCase _personUseCase = PersonUseCase.getInstance;

  bool get pendingCompetitionsStatus => SharedPref.instance.pendingCompetition;
  set pendingCompetitionsStatus(bool value) => SharedPref.instance.pendingCompetition = value;

  Future<Result<List<Competition>>> getCompetitions() => safeCall(() async {
        if (_memory.competitions.isEmpty) {
          List<Competition> list = await FireDatabase().getCompetitions();
          _memory.competitions = list;
          return list;
        } else {
          return _memory.competitions;
        }
      });

  Future<Result<Competition>> getCompetition(String id) => safeCall(() async {
        Competition competition = await FireDatabase().getCompetition(id);
        int index = _memory.competitions.indexWhere((element) => element.id == id);
        if (index != -1) {
          _memory.competitions[index] = competition;
        }
        return competition;
      });

  Future<Result<List<Competition>>> getPendingCompetitions() => safeCall(() async {
        List<Competition> list = await FireDatabase().getPendingCompetitions();
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
            fcmToken: await FireMessaging().getToken(),
            habitId: habit.id,
            color: habit.colorCode,
            score: await FireDatabase().hasDoneAtDay(habit.id, date) ? ScoreControl.DAY_DONE_POINT : 0,
            you: true);

        Competition competition = await FireDatabase().createCompetition(
            Competition(title: title, initialDate: date, competitors: [competitor], invitations: invitations));

        //TODO: Enviar notificações

        FireAnalytics().sendCreateCompetition(title, habit.habit, invitations.length);

        _memory.competitions.add(competition);

        return competition;
      });

  Future<Result> updateCompetition(String id, String title) => safeCall(() async {
        await FireDatabase().updateCompetition(id, title);
        int index = _memory.competitions.indexWhere((element) => element.id == id);
        if (index != -1) {
          _memory.competitions[index].title = title;
        }
      });

  Future<Result> removeCompetitor(Competition competition) => safeCall(() async {
        await FireDatabase().removeCompetitor(competition.id, _personUseCase.uid, competition.competitors.length == 1);
        _memory.competitions.removeWhere((element) => element.id == competition.id);
      });

  Future<Result> inviteCompetitor(String competitionId, List<String> competitorId, List<String> fcmTokens) =>
      safeCall(() async {
        Competition competition = (await getCompetition(competitionId)).absoluteResult();
        if (competition.competitors.length < MAX_COMPETITORS) {
          await FireDatabase().inviteCompetitor(competitionId, competitorId);
          //TODO: Enviar notificações
        } else {
          throw "Máximo de competidores atingido.";
        }
      });

  Future<Result> acceptCompetitionRequest(String competitionId, Competition competition, Competitor competitor) =>
      safeCall(() async {
        Competition competition = (await getCompetition(competitionId)).absoluteResult();
        if (competition.competitors.length < MAX_COMPETITORS) {
          await FireDatabase().acceptCompetitionRequest(competitionId, competitor);
          _memory.competitions.add(competition);
          //TODO: Enviar notificações
        } else {
          throw "Máximo de competidores atingido.";
        }
      });

  Future<Result> declineCompetitionRequest(String id) => safeCall(() async {
        return await FireDatabase().declineCompetitionRequest(id);
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
