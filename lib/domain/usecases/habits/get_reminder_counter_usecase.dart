import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/no_params.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetReminderCounterUsecase extends BaseUsecase<NoParams, int> {
  GetReminderCounterUsecase(this._userRepository);

  final IUserRepository _userRepository;

  @override
  Future<int> getRawFuture(NoParams params) {
    return _userRepository.getReminderCounter();
  }
}
