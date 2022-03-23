import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class GetRankingFriendsUsecase extends BaseUsecase<int, List<Person>> {
  final IFireDatabase _fireDatabase;

  GetRankingFriendsUsecase(this._fireDatabase);

  @override
  Future<List<Person>> getRawFuture(int params) {
    return _fireDatabase.getRankingFriends(params);
  }
}
