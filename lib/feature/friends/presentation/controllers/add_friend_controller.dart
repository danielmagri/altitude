import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/feature/friends/domain/usecases/accept_request_usecase.dart';
import 'package:altitude/feature/friends/domain/usecases/cancel_friend_request_usecase.dart';
import 'package:altitude/feature/friends/domain/usecases/friend_request_usecase.dart';
import 'package:altitude/feature/friends/domain/usecases/search_email_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'add_friend_controller.g.dart';

@LazySingleton()
class AddFriendController = _AddFriendControllerBase with _$AddFriendController;

abstract class _AddFriendControllerBase with Store {
  final SearchEmailUsecase _searchEmailUsecase;
  final FriendRequestUsecase _friendRequestUsecase;
  final CancelFriendRequestUsecase _cancelFriendRequestUsecase;
  final AcceptRequestUsecase _acceptRequestUsecase;

  _AddFriendControllerBase(this._searchEmailUsecase, this._friendRequestUsecase,
      this._cancelFriendRequestUsecase, this._acceptRequestUsecase);

  DataState<List<Person>> searchResult = DataState();

  Future<void> searchFriend(String email) async {
    searchResult.setLoadingState();
    List<Person> list =
        (await _searchEmailUsecase.call(email)).absoluteResult();
    searchResult.setSuccessState(list);
  }

  Future sendFriendRequest(String? uid) async {
    return (await _friendRequestUsecase.call(uid)).absoluteResult();
  }

  Future<void> cancelFriendRequest(String? uid) async {
    return (await _cancelFriendRequestUsecase.call(uid)).absoluteResult();
  }

  Future<void> acceptFriendRequest(String? uid) async {
    return (await _acceptRequestUsecase.call(uid)).absoluteResult();
  }
}
