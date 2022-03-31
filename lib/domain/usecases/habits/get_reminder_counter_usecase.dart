import 'package:altitude/data/repository/user_repository.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/model/no_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetReminderCounterUsecase extends BaseUsecase<NoParams, int> {
  final IUserRepository _userRepository;

  GetReminderCounterUsecase(this._userRepository);

  @override
  Future<int> getRawFuture(NoParams params) {
    return _userRepository.getReminderCounter();
  }
}
