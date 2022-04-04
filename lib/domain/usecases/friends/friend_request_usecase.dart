import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/friends_repository.dart';
import 'package:altitude/data/repository/notifications_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FriendRequestUsecase extends BaseUsecase<String, void> {
  FriendRequestUsecase(
    this._friendsRepository,
    this._notificationsRepository,
    this._userRepository,
  );

  final IFriendsRepository _friendsRepository;
  final INotificationsRepository _notificationsRepository;
  final IUserRepository _userRepository;

  @override
  Future<void> getRawFuture(String params) async {
    final token = await _friendsRepository.sendFriendRequest(params);
    final userName =
        await _userRepository.getUserData(false).then((value) => value.name);

    await _notificationsRepository.sendInviteFriendNotification(
      userName ?? '',
      token,
    );
  }
}
