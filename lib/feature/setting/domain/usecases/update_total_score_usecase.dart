import 'package:altitude/common/controllers/LevelControl.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class UpdateTotalScoreUsecase extends BaseUsecase<int, void> {
  final Memory _memory;
  final IFireDatabase _fireDatabase;

  UpdateTotalScoreUsecase(this._memory, this._fireDatabase);

  @override
  Future<void> getRawFuture(int params) async {
    _memory.clear();
    return _fireDatabase.updateTotalScore(
        params, LevelControl.getLevel(params));
  }
}
