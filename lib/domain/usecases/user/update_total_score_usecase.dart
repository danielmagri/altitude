import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateTotalScoreUsecase extends BaseUsecase<int, void> {
  UpdateTotalScoreUsecase(this._userRepository);

  final IUserRepository _userRepository;

  @override
  Future<void> getRawFuture(int params) async {
    return _userRepository.updateTotalScore(params);
  }
}
