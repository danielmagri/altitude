import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/no_params.dart';
import 'package:altitude/infra/services/Memory.dart';
import 'package:altitude/infra/interface/i_fire_auth.dart';
import 'package:injectable/injectable.dart';

@injectable
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
