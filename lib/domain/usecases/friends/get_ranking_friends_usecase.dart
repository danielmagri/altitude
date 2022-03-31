import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetRankingFriendsUsecase extends BaseUsecase<int, List<Person>> {
  final IFireDatabase _fireDatabase;

  GetRankingFriendsUsecase(this._fireDatabase);

  @override
  Future<List<Person>> getRawFuture(int params) {
    return _fireDatabase.getRankingFriends(params);
  }
}
