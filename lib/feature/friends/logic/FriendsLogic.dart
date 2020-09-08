import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/controllers/ScoreControl.dart';
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

  Future<void> fetchData() async {
    try {
      checkPendingFriendsStatus();

      var _friends = (await personUseCase.getFriends()).asObservable();
      var _ranking = _friends.toList().asObservable();

      _ranking
          .add(Person(name: personUseCase.name, email: personUseCase.email, score: ScoreControl().score, you: true));

      sortLists(_friends, _ranking);

      friends.setData(_friends);
      ranking.setData(_ranking);
    } catch (error) {
      friends.setError(error);
      ranking.setError(error);

      throw error;
    }
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
