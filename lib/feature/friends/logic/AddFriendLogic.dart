import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:mobx/mobx.dart';
part 'AddFriendLogic.g.dart';

class AddFriendLogic = _AddFriendLogicBase with _$AddFriendLogic;

abstract class _AddFriendLogicBase with Store {
  final PersonUseCase personUseCase = PersonUseCase.getInstance;
  
  DataState<List<Person>> searchResult = DataState();

  Future<void> searchFriend(String email) async {
    searchResult.setLoading();
    searchResult.setData(await personUseCase.searchEmail(email));
  }

  Future<void> sendFriendRequest(String uid) async {
    return await personUseCase.friendRequest(uid);
  }

  Future<void> cancelFriendRequest(String uid) async {
    return await personUseCase.cancelFriendRequest(uid);
  }

  Future<void> acceptFriendRequest(String uid) async {
    return await personUseCase.acceptRequest(uid);
  }
}
