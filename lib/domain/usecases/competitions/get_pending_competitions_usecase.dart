import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/infra/services/shared_pref/shared_pref.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/no_params.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPendingCompetitionsUsecase
    extends BaseUsecase<NoParams, List<Competition>> {
  final IFireDatabase _fireDatabase;
  final SharedPref _sharedPref;

  GetPendingCompetitionsUsecase(this._fireDatabase, this._sharedPref);

  @override
  Future<List<Competition>> getRawFuture(NoParams params) async {
    List<Competition> list = await _fireDatabase.getPendingCompetitions();
    _sharedPref.pendingCompetition = list.isNotEmpty;
    return list;
  }
}
