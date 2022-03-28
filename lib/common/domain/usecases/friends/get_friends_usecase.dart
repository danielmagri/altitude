import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';

class GetFriendsUsecase extends BaseUsecase<NoParams, List<Person>> {
  final IFireDatabase _fireDatabase;

  GetFriendsUsecase(this._fireDatabase);

  @override
  Future<List<Person>> getRawFuture(NoParams params) {
    return _fireDatabase.getFriendsDetails();
  }
}
