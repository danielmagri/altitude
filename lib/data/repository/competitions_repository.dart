import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';

abstract class ICompetitionsRepository {
  Future<List<Competition>> getCompetitions(bool fromServer);
  Future<Competition> getCompetition(String id);
}

class CompetitionsRepository extends ICompetitionsRepository {
  final Memory _memory;
  final IFireDatabase _fireDatabase;

  CompetitionsRepository(this._memory, this._fireDatabase);

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
}
