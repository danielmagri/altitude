import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/friends_repository.dart';
import 'package:altitude/data/repository/notifications_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AcceptRequestUsecase extends BaseUsecase<String, void> {
  final IFriendsRepository _friendsRepository;
  final INotificationsRepository _notificationsRepository;
  final IUserRepository _userRepository;

  AcceptRequestUsecase(this._friendsRepository, this._notificationsRepository,
      this._userRepository);

  @override
  Future<void> getRawFuture(String params) async {
    final token = await _friendsRepository.acceptRequest(params);
    final userName =
        await _userRepository.getUserData(false).then((value) => value.name);
    await _notificationsRepository.acceptFriendNotification(
      userName ?? '',
      token,
    );
  }
}
