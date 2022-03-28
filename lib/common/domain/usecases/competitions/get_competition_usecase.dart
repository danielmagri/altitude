import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';

class GetCompetitionUsecase extends BaseUsecase<String, Competition> {
  final Memory _memory;
  final IFireDatabase _fireDatabase;

  GetCompetitionUsecase(this._memory, this._fireDatabase);

  @override
  Future<Competition> getRawFuture(String params) async {
    Competition competition = await _fireDatabase.getCompetition(params);
    int index =
        _memory.competitions.indexWhere((element) => element.id == params);
    if (index != -1) {
      _memory.competitions[index] = competition;
    }
    return competition;
  }
}
