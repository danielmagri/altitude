import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/shared_pref/shared_pref.dart';
import 'package:altitude/core/model/data_state.dart';
import 'package:altitude/feature/friends/domain/usecases/accept_request_usecase.dart';
import 'package:altitude/feature/friends/domain/usecases/decline_request_usecase.dart';
import 'package:altitude/feature/friends/domain/usecases/get_pending_friends_usecase.dart';
import 'package:mobx/mobx.dart';
part 'pending_friends_controller.g.dart';

class PendingFriendsController = _PendingFriendsControllerBase
    with _$PendingFriendsController;

abstract class _PendingFriendsControllerBase with Store {
  final GetPendingFriendsUsecase _getPendingFriendsUsecase;
  final AcceptRequestUsecase _acceptRequestUsecase;
  final DeclineRequestUsecase _declineRequestUsecase;
  final SharedPref _sharedPref;

  _PendingFriendsControllerBase(
      this._getPendingFriendsUsecase,
      this._acceptRequestUsecase,
      this._declineRequestUsecase,
      this._sharedPref);

  DataState<ObservableList<Person>> pendingFriends = DataState();
  List<Person> addedFriends = [];

  Future<void> fetchData() async {
    (await _getPendingFriendsUsecase.call()).result((data) {
      _sharedPref.pendingFriends = data.isNotEmpty;
      pendingFriends.setSuccessState(data.asObservable());
    }, (error) {
      pendingFriends.setErrorState(error);
      throw error;
    });
  }

  @action
  Future<void> acceptRequest(Person person) async {
    await _acceptRequestUsecase
        .call(person.uid)
        .resultComplete((data) => data, (error) => throw error);
    addedFriends.add(person);
    pendingFriends.data!.removeWhere((item) => item.uid == person.uid);

    if (pendingFriends.data!.isEmpty) _sharedPref.pendingFriends = false;
  }

  @action
  Future<void> declineRequest(Person person) async {
    await _declineRequestUsecase
        .call(person.uid)
        .resultComplete((data) => data, (error) => throw error);
    pendingFriends.data!.removeWhere((item) => item.uid == person.uid);

    if (pendingFriends.data!.isEmpty) _sharedPref.pendingFriends = false;
  }
}
