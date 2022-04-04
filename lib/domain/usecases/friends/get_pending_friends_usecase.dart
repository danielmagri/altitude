import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/model/no_params.dart';
import 'package:altitude/data/repository/friends_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPendingFriendsUsecase extends BaseUsecase<NoParams, List<Person>> {
  GetPendingFriendsUsecase(this._friendsRepository);

  final IFriendsRepository _friendsRepository;

  @override
  Future<List<Person>> getRawFuture(NoParams params) async {
    return _friendsRepository.getPendingFriends();
  }
}
