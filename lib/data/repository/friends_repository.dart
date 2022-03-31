import 'package:altitude/common/model/Person.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:injectable/injectable.dart';

abstract class IFriendsRepository {
  Future<List<Person>> getFriends();
}

@Injectable(as: IFriendsRepository)
class FriendsRepository extends IFriendsRepository {
  final IFireDatabase _fireDatabase;

  FriendsRepository(this._fireDatabase);

  @override
  Future<List<Person>> getFriends() async {
    return _fireDatabase.getFriendsDetails();
  }
}
