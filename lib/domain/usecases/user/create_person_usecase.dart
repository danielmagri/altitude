import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreatePersonUsecase extends BaseUsecase<CreatePersonParams, void> {
  CreatePersonUsecase(this._userRepository);

  final IUserRepository _userRepository;

  @override
  Future<void> getRawFuture(CreatePersonParams params) async {
    return _userRepository.createPerson(
      params.level,
      params.reminderCounter,
      params.score,
      params.friends,
      params.pendingFriends,
    );
  }
}

class CreatePersonParams {
  CreatePersonParams({
    this.level,
    this.reminderCounter,
    this.score,
    this.friends,
    this.pendingFriends,
  });

  final int? level;
  final int? reminderCounter;
  final int? score;
  final List<String?>? friends;
  final List<String?>? pendingFriends;
}
