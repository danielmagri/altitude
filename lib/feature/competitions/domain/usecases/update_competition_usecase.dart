import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class UpdateCompetitionUsecase
    extends BaseUsecase<UpdateCompetitionParams, void> {
  final IFireDatabase _fireDatabase;
  final Memory _memory;

  UpdateCompetitionUsecase(this._fireDatabase, this._memory);

  @override
  Future<void> getRawFuture(UpdateCompetitionParams params) async {
    await _fireDatabase.updateCompetition(params.competitionId, params.title);
    int index = _memory.competitions
        .indexWhere((element) => element.id == params.competitionId);
    if (index != -1) {
      _memory.competitions[index].title = params.title;
    }
  }
}

class UpdateCompetitionParams {
  final String competitionId;
  final String title;

  UpdateCompetitionParams({required this.competitionId, required this.title});
}
