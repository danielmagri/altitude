import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/infra/interface/i_fire_analytics.dart';
import 'package:altitude/infra/interface/i_fire_auth.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:altitude/infra/services/Memory.dart';
import 'package:altitude/infra/services/shared_pref/shared_pref.dart';
import 'package:injectable/injectable.dart';

abstract class ICompetitionsRepository {
  Future<List<Competition>> getCompetitions(bool fromServer);
  Future<Competition> getCompetition(String id);
  Future<void> updateCompetition(String competitionId, String title);
  Future<List<Competition>> getPendingCompetitions();
  Future<void> inviteCompetitor(
    String competitionId,
    List<String?> competitorsId,
  );
  Future<void> removeCompetitor(Competition competition);
  Future<void> declineCompetitionRequest(String competitionId);
  Future<void> acceptCompetitionRequest(
    String competitionId,
    Competitor competitor,
    Competition competition,
  );
  Future<Competition> createCompetition(
    Competition competition,
    String habitText,
  );
}

@Injectable(as: ICompetitionsRepository)
class CompetitionsRepository extends ICompetitionsRepository {
  CompetitionsRepository(
    this._memory,
    this._fireDatabase,
    this._fireAuth,
    this._sharedPref,
    this._fireAnalytics,
  );

  final Memory _memory;
  final IFireDatabase _fireDatabase;
  final IFireAuth _fireAuth;
  final SharedPref _sharedPref;
  final IFireAnalytics _fireAnalytics;

  @override
  Future<List<Competition>> getCompetitions(bool fromServer) async {
    if (_memory.competitions.isEmpty || fromServer) {
      List<Competition> list = await _fireDatabase.getCompetitions();
      _memory.competitions = list;
      return list;
    } else {
      return _memory.competitions;
    }
  }

  @override
  Future<Competition> getCompetition(String id) async {
    Competition competition = await _fireDatabase.getCompetition(id);
    int index = _memory.competitions.indexWhere((element) => element.id == id);
    if (index != -1) {
      _memory.competitions[index] = competition;
    }
    return competition;
  }

  @override
  Future<void> updateCompetition(String competitionId, String title) async {
    await _fireDatabase.updateCompetition(competitionId, title);
    int index = _memory.competitions
        .indexWhere((element) => element.id == competitionId);
    if (index != -1) {
      _memory.competitions[index].title = title;
    }
  }

  @override
  Future<List<Competition>> getPendingCompetitions() async {
    List<Competition> list = await _fireDatabase.getPendingCompetitions();
    _sharedPref.pendingCompetition = list.isNotEmpty;
    return list;
  }

  @override
  Future<void> inviteCompetitor(
    String competitionId,
    List<String?> competitorsId,
  ) async {
    await _fireDatabase.inviteCompetitor(competitionId, competitorsId);
  }

  @override
  Future<void> removeCompetitor(Competition competition) async {
    await _fireDatabase.removeCompetitor(
      competition.id,
      _fireAuth.getUid(),
      competition.competitors!.length == 1,
    );
    _memory.competitions.removeWhere((element) => element.id == competition.id);
  }

  @override
  Future<void> declineCompetitionRequest(String competitionId) async {
    await _fireDatabase.declineCompetitionRequest(competitionId);
  }

  @override
  Future<void> acceptCompetitionRequest(
    String competitionId,
    Competitor competitor,
    Competition competition,
  ) async {
    await _fireDatabase.acceptCompetitionRequest(competitionId, competitor);
    competition.competitors!.add(competitor);
    _memory.competitions.add(competition);
  }

  @override
  Future<Competition> createCompetition(
    Competition competition,
    String habitText,
  ) async {
    Competition newCompetition =
        await _fireDatabase.createCompetition(competition);

    _fireAnalytics.sendCreateCompetition(
      competition.title ?? '',
      habitText,
      competition.invitations?.length ?? 0,
    );

    _memory.competitions.add(competition);
    return newCompetition;
  }
}
