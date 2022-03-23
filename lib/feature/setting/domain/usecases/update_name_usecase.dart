import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class UpdateNameUsecase extends BaseUsecase<UpdateNameParams, void> {
  final Memory _memory;
  final IFireAuth _fireAuth;
  final IFireDatabase _fireDatabase;

  UpdateNameUsecase(this._memory, this._fireAuth, this._fireDatabase);

  @override
  Future<void> getRawFuture(UpdateNameParams params) async {
    await _fireAuth.setName(params.name);
    await _fireDatabase.updateName(params.name, params.competitionsId);
    _memory.person?.name = params.name;
  }
}

class UpdateNameParams {
  final String name;
  final List<String?> competitionsId;

  UpdateNameParams({required this.name, required this.competitionsId});
}