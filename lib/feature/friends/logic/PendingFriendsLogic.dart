import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/controllers/UserControl.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:mobx/mobx.dart';
part 'PendingFriendsLogic.g.dart';

class PendingFriendsLogic = _PendingFriendsLogicBase with _$PendingFriendsLogic;

abstract class _PendingFriendsLogicBase with Store {
  DataState<ObservableList<Person>> pendingFriends = DataState();
  List<Person> addedFriends = [];

  Future<void> fetchData() async {
    try {
      var _pendingFriends = (await UserControl().getPendingFriends()).asObservable();

      UserControl().setPendingFriendsStatus(_pendingFriends.isNotEmpty);

      pendingFriends.setData(_pendingFriends);
    } catch (error) {
      pendingFriends.setError(error);
      throw error;
    }
  }

  @action
  Future<void> acceptRequest(Person person) async {
    await UserControl().acceptRequest(person.uid);
    addedFriends.add(person);
    pendingFriends.data.removeWhere((item) => item.uid == person.uid);

    if (pendingFriends.data.isEmpty) UserControl().setPendingFriendsStatus(false);
  }

  @action
  Future<void> declineRequest(Person person) async {
    await UserControl().declineRequest(person.uid);
    pendingFriends.data.removeWhere((item) => item.uid == person.uid);

    if (pendingFriends.data.isEmpty) UserControl().setPendingFriendsStatus(false);
  }
}
