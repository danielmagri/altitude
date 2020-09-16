import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:mobx/mobx.dart';
part 'FriendsLogic.g.dart';

class FriendsLogic = _FriendsLogicBase with _$FriendsLogic;

abstract class _FriendsLogicBase with Store {
  final PersonUseCase personUseCase = PersonUseCase.getInstance;

  @observable
  bool pendingStatus = false;

  DataState<ObservableList<Person>> friends = DataState();
  DataState<ObservableList<Person>> ranking = DataState();

  Future<bool> get isLogged async => personUseCase.isLogged;

  Future fetchData() async {
    checkPendingFriendsStatus();

    return (await personUseCase.getFriends()).result((data) async {
      var _friends = data.toList().asObservable();
      var _ranking = data.toList().asObservable();

      Person me = (await personUseCase.getPerson()).absoluteResult();
      me.you = true;

      _ranking.add(me);

      sortLists(_friends, _ranking);

      friends.setData(_friends);
      ranking.setData(_ranking);
    }, (error) {
      friends.setError(error);
      ranking.setError(error);
      throw error;
    });
  }

  @action
  void checkPendingFriendsStatus() {
    pendingStatus = personUseCase.pendingFriendsStatus;
  }

  void setEmptyData() {
    friends.setData(ObservableList<Person>());
    ranking.setData(ObservableList<Person>());
  }

  void addPersons(ObservableList<Person> persons) {
    friends.data.addAll(persons);
    ranking.data.addAll(persons);

    sortLists(friends.data, ranking.data);
  }

  @action
  void sortLists(ObservableList<Person> friends, ObservableList<Person> ranking) {
    friends.sort((a, b) => a.name.compareTo(b.name));
    ranking.sort((a, b) => -a.score.compareTo(b.score));
  }

  @action
  Future<void> removeFriend(String uid) async {
    await personUseCase.removeFriend(uid);
    ranking.data.removeWhere((person) => person.uid == uid);
    friends.data.removeWhere((person) => person.uid == uid);
  }
}
