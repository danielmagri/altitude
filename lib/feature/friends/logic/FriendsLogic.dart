import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/controllers/ScoreControl.dart';
import 'package:altitude/common/controllers/UserControl.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:mobx/mobx.dart';
part 'FriendsLogic.g.dart';

class FriendsLogic = _FriendsLogicBase with _$FriendsLogic;

abstract class _FriendsLogicBase with Store {
  @observable
  bool pendingStatus = false;

  DataState<ObservableList<Person>> friends = DataState();
  DataState<ObservableList<Person>> ranking = DataState();

  Future<bool> get isLogged async => await UserControl().isLogged();

  @action
  Future<void> fetchData() async {
    try {
      var _friends = (await UserControl().getFriends()).asObservable();
      var _ranking = _friends.toList().asObservable();

      _ranking.add(Person(
          name: await UserControl().getName(),
          email: await UserControl().getEmail(),
          score: ScoreControl().score,
          you: true));

      sortLists(_friends, _ranking);

      friends.setData(_friends);
      ranking.setData(_ranking);
      pendingStatus = UserControl().getPendingFriendsStatus();
    } catch (error) {
      friends.setError(error);
      ranking.setError(error);

      throw error;
    }
  }

  void setEmptyData() {
    friends.setData(List<Person>());
    ranking.setData(List<Person>());
  }

  void addPersons(List<Person> persons) {
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
    await UserControl().removeFriend(uid);
    ranking.data.removeWhere((person) => person.uid == uid);
    friends.data.removeWhere((person) => person.uid == uid);
  }
}
