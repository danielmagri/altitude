import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';

class LogoutUsecase extends BaseUsecase<NoParams, void> {
  final Memory _memory;
  final IFireAuth _fireAuth;

  LogoutUsecase(this._memory, this._fireAuth);

  @override
  Future<void> getRawFuture(NoParams params) async {
    _memory.clear();
    await _fireAuth.logout();
  }
}
