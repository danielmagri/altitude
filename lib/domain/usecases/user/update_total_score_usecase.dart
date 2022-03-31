import 'package:altitude/common/constant/level_utils.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/infra/services/Memory.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateTotalScoreUsecase extends BaseUsecase<int, void> {
  final Memory _memory;
  final IFireDatabase _fireDatabase;

  UpdateTotalScoreUsecase(this._memory, this._fireDatabase);

  @override
  Future<void> getRawFuture(int params) async {
    _memory.clear();
    return _fireDatabase.updateTotalScore(params, LevelUtils.getLevel(params));
  }
}
