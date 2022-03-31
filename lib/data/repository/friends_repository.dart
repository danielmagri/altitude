import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';

abstract class IFriendsRepository {
  Future<List<Person>> getFriends();
}

class FriendsRepository extends IFriendsRepository {
  final IFireDatabase _fireDatabase;

  FriendsRepository(this._fireDatabase);

  @override
  Future<List<Person>> getFriends() async {
    return _fireDatabase.getFriendsDetails();
  }
}
