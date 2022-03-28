import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';

class RemoveCompetitorUsecase extends BaseUsecase<Competition, void> {
  final IFireDatabase _fireDatabase;
  final Memory _memory;
  final IFireAuth _fireAuth;

  RemoveCompetitorUsecase(this._fireDatabase, this._memory, this._fireAuth);

  @override
  Future<void> getRawFuture(Competition params) async {
    await _fireDatabase.removeCompetitor(
        params.id, _fireAuth.getUid(), params.competitors!.length == 1);
    _memory.competitions.removeWhere((element) => element.id == params.id);
  }
}
