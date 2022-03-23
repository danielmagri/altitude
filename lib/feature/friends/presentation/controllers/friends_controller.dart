import 'package:altitude/common/domain/usecases/friends/get_friends_usecase.dart';
import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'friends_controller.g.dart';

@LazySingleton()
class FriendsController = _FriendsControllerBase with _$FriendsController;

abstract class _FriendsControllerBase with Store {
  final GetFriendsUsecase _getFriendsUsecase;
  final GetUserDataUsecase _getUserDataUsecase;
  final PersonUseCase personUseCase;

  _FriendsControllerBase(
      this.personUseCase, this._getFriendsUsecase, this._getUserDataUsecase);

  @observable
  bool pendingStatus = false;

  DataState<ObservableList<Person>> friends = DataState();
  DataState<ObservableList<Person>> ranking = DataState();

  Future fetchData() async {
    checkPendingFriendsStatus();

    return (await _getFriendsUsecase.call()).result((data) async {
      var _friends = data.toList().asObservable();
      var _ranking = data.toList().asObservable();

      Person me = (await _getUserDataUsecase.call(false)).absoluteResult();
      me.you = true;

      _ranking.add(me);

      sortLists(_friends, _ranking);

      friends.setSuccessState(_friends);
      ranking.setSuccessState(_ranking);
    }, (error) {
      friends.setErrorState(error);
      ranking.setErrorState(error);
      throw error;
    });
  }

  @action
  void checkPendingFriendsStatus() {
    pendingStatus = personUseCase!.pendingFriendsStatus;
  }

  void setEmptyData() {
    friends.setSuccessState(ObservableList<Person>());
    ranking.setSuccessState(ObservableList<Person>());
  }

  void addPersons(ObservableList<Person> persons) {
    friends.data!.addAll(persons);
    ranking.data!.addAll(persons);

    sortLists(friends.data!, ranking.data!);
  }

  @action
  void sortLists(
      ObservableList<Person> friends, ObservableList<Person> ranking) {
    friends.sort((a, b) => a.name!.compareTo(b.name!));
    ranking.sort((a, b) => -a.score!.compareTo(b.score!));
  }

  @action
  Future<void> removeFriend(String? uid) async {
    (await personUseCase!.removeFriend(uid)).absoluteResult();
    ranking.data!.removeWhere((person) => person.uid == uid);
    friends.data!.removeWhere((person) => person.uid == uid);
  }
}
