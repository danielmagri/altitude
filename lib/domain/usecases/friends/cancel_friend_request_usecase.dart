import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/friends_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CancelFriendRequestUsecase extends BaseUsecase<String, void> {
  final IFriendsRepository _friendsRepository;

  CancelFriendRequestUsecase(this._friendsRepository);

  @override
  Future<void> getRawFuture(String params) async {
    return _friendsRepository.cancelRequest(params);
  }
}
