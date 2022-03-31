import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/infra/services/Memory.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@injectable
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
