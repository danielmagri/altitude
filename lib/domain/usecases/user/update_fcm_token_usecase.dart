import 'package:altitude/data/repository/user_repository.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/no_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateFCMTokenUsecase extends BaseUsecase<NoParams, void> {
  final IUserRepository _userRepository;

  UpdateFCMTokenUsecase(this._userRepository);

  @override
  Future<void> getRawFuture(NoParams params) async {
    await _userRepository.updateFCMToken();
  }
}
