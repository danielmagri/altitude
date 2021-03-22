import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/model/DataState.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
part 'AddFriendLogic.g.dart';

@LazySingleton()
class AddFriendLogic = _AddFriendLogicBase with _$AddFriendLogic;

abstract class _AddFriendLogicBase with Store {
  final PersonUseCase personUseCase;

  _AddFriendLogicBase(this.personUseCase);

  DataState<List<Person>> searchResult = DataState();

  Future<void> searchFriend(String email) async {
    searchResult.setLoading();
    List<Person> list = (await personUseCase.searchEmail(email)).absoluteResult() ?? [];
    searchResult.setData(list);
  }

  Future sendFriendRequest(String uid) async {
    return (await personUseCase.friendRequest(uid)).absoluteResult();
  }

  Future<void> cancelFriendRequest(String uid) async {
    return (await personUseCase.cancelFriendRequest(uid)).absoluteResult();
  }

  Future<void> acceptFriendRequest(String uid) async {
    return (await personUseCase.acceptRequest(uid)).absoluteResult();
  }
}
