import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/data/repository/friends_repository.dart';
import 'package:altitude/domain/models/person_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetRankingFriendsUsecase extends BaseUsecase<int, List<Person>> {
  GetRankingFriendsUsecase(this._friendsRepository);

  final IFriendsRepository _friendsRepository;

  @override
  Future<List<Person>> getRawFuture(int params) {
    return _friendsRepository.getRankingFriends(params);
  }
}
