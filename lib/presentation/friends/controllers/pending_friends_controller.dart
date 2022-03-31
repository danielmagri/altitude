import 'package:altitude/common/model/Person.dart';
import 'package:altitude/infra/services/shared_pref/shared_pref.dart';
import 'package:altitude/common/model/data_state.dart';
import 'package:altitude/common/model/no_params.dart';
import 'package:altitude/domain/usecases/friends/accept_request_usecase.dart';
import 'package:altitude/domain/usecases/friends/decline_request_usecase.dart';
import 'package:altitude/domain/usecases/friends/get_pending_friends_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'pending_friends_controller.g.dart';

@lazySingleton
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
    (await _getPendingFriendsUsecase.call(NoParams())).result((data) {
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
        .call(person.uid!)
        .resultComplete((data) => data, (error) => throw error);
    addedFriends.add(person);
    pendingFriends.data!.removeWhere((item) => item.uid == person.uid);

    if (pendingFriends.data!.isEmpty) _sharedPref.pendingFriends = false;
  }

  @action
  Future<void> declineRequest(Person person) async {
    await _declineRequestUsecase
        .call(person.uid!)
        .resultComplete((data) => data, (error) => throw error);
    pendingFriends.data!.removeWhere((item) => item.uid == person.uid);

    if (pendingFriends.data!.isEmpty) _sharedPref.pendingFriends = false;
  }
}
