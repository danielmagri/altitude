import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/infra/services/Memory.dart';
import 'package:altitude/infra/interface/i_fire_auth.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@injectable
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
