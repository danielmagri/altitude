import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';

class GetCompetitionsUsecase extends BaseUsecase<bool, List<Competition>> {
  final Memory _memory;
  final IFireDatabase _fireDatabase;

  GetCompetitionsUsecase(this._memory, this._fireDatabase);

  @override
  Future<List<Competition>> getRawFuture(bool params) async {
    if (_memory.competitions.isEmpty || params) {
      List<Competition> list = await _fireDatabase.getCompetitions();
      _memory.competitions = list;
      return list;
    } else {
      return _memory.competitions;
    }
  }
}
