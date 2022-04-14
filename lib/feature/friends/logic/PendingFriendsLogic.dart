import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'PendingFriendsLogic.g.dart';

@LazySingleton()
class PendingFriendsLogic = _PendingFriendsLogicBase with _$PendingFriendsLogic;

abstract class _PendingFriendsLogicBase with Store {
  final PersonUseCase personUseCase;

  _PendingFriendsLogicBase(this.personUseCase);

  DataState<ObservableList<Person>> pendingFriends = DataState();
  List<Person> addedFriends = [];

  Future<void> fetchData() async {
    (await personUseCase.getPendingFriends()).result((data) {
      personUseCase.pendingFriendsStatus = data.isNotEmpty;
      pendingFriends.setData(data.asObservable());
    }, (error) {
      pendingFriends.setError(error);
      throw error;
    });
  }

  @action
  Future<void> acceptRequest(Person person) async {
    (await personUseCase.acceptRequest(person.uid)).absoluteResult();
    addedFriends.add(person);
    pendingFriends.data.removeWhere((item) => item.uid == person.uid);

    if (pendingFriends.data.isEmpty) personUseCase.pendingFriendsStatus = false;
  }

  @action
  Future<void> declineRequest(Person person) async {
    (await personUseCase.declineRequest(person.uid)).absoluteResult();
    pendingFriends.data.removeWhere((item) => item.uid == person.uid);

    if (pendingFriends.data.isEmpty) personUseCase.pendingFriendsStatus = false;
  }
}
