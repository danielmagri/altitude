import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:mobx/mobx.dart';
part 'PendingFriendsLogic.g.dart';

class PendingFriendsLogic = _PendingFriendsLogicBase with _$PendingFriendsLogic;

abstract class _PendingFriendsLogicBase with Store {
  final PersonUseCase personUseCase = PersonUseCase.getInstance;

  DataState<ObservableList<Person>> pendingFriends = DataState();
  List<Person> addedFriends = [];

  Future<void> fetchData() async {
    try {
      var _pendingFriends = (await personUseCase.getPendingFriends()).asObservable();

      personUseCase.pendingFriendsStatus = _pendingFriends.isNotEmpty;

      pendingFriends.setData(_pendingFriends);
    } catch (error) {
      pendingFriends.setError(error);
      throw error;
    }
  }

  @action
  Future<void> acceptRequest(Person person) async {
    await personUseCase.acceptRequest(person.uid);
    addedFriends.add(person);
    pendingFriends.data.removeWhere((item) => item.uid == person.uid);

    if (pendingFriends.data.isEmpty) personUseCase.pendingFriendsStatus = false;
  }

  @action
  Future<void> declineRequest(Person person) async {
    await personUseCase.declineRequest(person.uid);
    pendingFriends.data.removeWhere((item) => item.uid == person.uid);

    if (pendingFriends.data.isEmpty) personUseCase.pendingFriendsStatus = false;
  }
}
