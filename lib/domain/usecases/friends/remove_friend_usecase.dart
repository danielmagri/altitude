import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/friends_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveFriendUsecase extends BaseUsecase<String, void> {
  RemoveFriendUsecase(this._friendsRepository);

  final IFriendsRepository _friendsRepository;

  @override
  Future<void> getRawFuture(String params) async {
    return _friendsRepository.removeFriend(params);
  }
}
