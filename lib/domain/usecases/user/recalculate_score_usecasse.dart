import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/no_params.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RecalculateScoreUsecase extends BaseUsecase<NoParams, void> {
  RecalculateScoreUsecase(this._userRepository);

  final IUserRepository _userRepository;


  @override
  Future<void> getRawFuture(NoParams params) async {
    return _userRepository.recalculateScore();
  }
}
