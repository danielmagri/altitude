import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@usecase
@Injectable()
class GetPendingFriendsUsecase extends BaseUsecase<NoParams, List<Person>> {
  final IFireDatabase _fireDatabase;

  GetPendingFriendsUsecase(this._fireDatabase);

  @override
  Future<List<Person>> getRawFuture(NoParams params) async {
    return await _fireDatabase.getPendingFriends();
  }
}
