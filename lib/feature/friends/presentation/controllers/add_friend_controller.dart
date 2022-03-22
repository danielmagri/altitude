import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'add_friend_controller.g.dart';

@LazySingleton()
class AddFriendController = _AddFriendControllerBase with _$AddFriendController;

abstract class _AddFriendControllerBase with Store {
  final PersonUseCase? personUseCase;

  _AddFriendControllerBase(this.personUseCase);

  DataState<List<Person>> searchResult = DataState();

  Future<void> searchFriend(String email) async {
    searchResult.setLoading();
    List<Person> list = (await personUseCase!.searchEmail(email)).absoluteResult();
    searchResult.setData(list);
  }

  Future sendFriendRequest(String? uid) async {
    return (await personUseCase!.friendRequest(uid)).absoluteResult();
  }

  Future<void> cancelFriendRequest(String? uid) async {
    return (await personUseCase!.cancelFriendRequest(uid)).absoluteResult();
  }

  Future<void> acceptFriendRequest(String? uid) async {
    return (await personUseCase!.acceptRequest(uid)).absoluteResult();
  }
}
