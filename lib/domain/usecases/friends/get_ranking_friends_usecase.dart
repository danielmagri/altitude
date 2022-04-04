import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/friends_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetRankingFriendsUsecase extends BaseUsecase<int, List<Person>> {
  final IFriendsRepository _friendsRepository;

  GetRankingFriendsUsecase(this._friendsRepository);

  @override
  Future<List<Person>> getRawFuture(int params) {
    return _friendsRepository.getRankingFriends(params);
  }
}
