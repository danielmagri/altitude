import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/model/no_params.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';

class IsLoggedUsecase extends BaseUsecase<NoParams, bool> {
  final IFireAuth _fireAuth;

  IsLoggedUsecase(this._fireAuth);

  @override
  Future<bool> getRawFuture(NoParams params) async {
    return _fireAuth.isLogged();
  }
}
