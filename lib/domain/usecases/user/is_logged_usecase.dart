import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:altitude/core/model/no_params.dart';

class IsLoggedUsecase extends BaseUsecase<NoParams, bool> {
  final IUserRepository _userRepository;

  IsLoggedUsecase(this._userRepository);

  @override
  Future<bool> getRawFuture(NoParams params) async {
    return _userRepository.isLogged();
  }
}
