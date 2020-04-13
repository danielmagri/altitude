import 'package:altitude/common/model/Person.dart';
import 'package:altitude/controllers/UserControl.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:mobx/mobx.dart';
part 'AddFriendLogic.g.dart';

class AddFriendLogic = _AddFriendLogicBase with _$AddFriendLogic;

abstract class _AddFriendLogicBase with Store {
  DataState<List<Person>> searchResult = DataState();

  Future<void> searchFriend(String email) async {
    searchResult.setLoading();
    searchResult.setData(await UserControl().searchEmail(email));
  }

  Future<void> sendFriendRequest(String uid) async {
    return await UserControl().friendRequest(uid);
  }

  Future<void> cancelFriendRequest(String uid) async {
    return await UserControl().cancelFriendRequest(uid);
  }

  Future<void> acceptFriendRequest(String uid) async {
    return await UserControl().acceptRequest(uid);
  }
}
