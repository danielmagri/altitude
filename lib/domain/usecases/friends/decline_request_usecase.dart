import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/friends_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeclineRequestUsecase extends BaseUsecase<String, void> {
  final IFriendsRepository _friendsRepository;

  DeclineRequestUsecase(this._friendsRepository);

  @override
  Future<void> getRawFuture(String params) async {
    return await _friendsRepository.declineRequest(params);
  }
}
