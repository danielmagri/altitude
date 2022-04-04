import 'package:altitude/data/repository/friends_repository.dart';
import 'package:altitude/data/repository/user_repository.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchEmailUsecase extends BaseUsecase<String, List<Person>> {
  final IFriendsRepository _friendsRepository;
  final IUserRepository _userRepository;

  SearchEmailUsecase(this._friendsRepository, this._userRepository);

  @override
  Future<List<Person>> getRawFuture(String params) async {
    final person = await _userRepository.getUserData(false);
    if (params != person.email) {
      List<String?> myPendingFriends = person.pendingFriends ?? [];
      return await _friendsRepository.searchEmail(params, myPendingFriends);
    } else {
      return [];
    }
  }
}
