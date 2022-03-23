import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class UpdateLevelUsecase extends BaseUsecase<int, void> {
  final IFireDatabase _fireDatabase;
  final Memory _memory;

  UpdateLevelUsecase(this._fireDatabase, this._memory);

  @override
  Future<void> getRawFuture(int params) async {
    await _fireDatabase.updateLevel(params);
    _memory.person!.level = params;
  }
}
