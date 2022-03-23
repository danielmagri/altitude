import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@usecase
@Injectable()
class RemoveFriendUsecase extends BaseUsecase<String, void> {
  final IFireDatabase _fireDatabase;
  final IFireAuth _fireAuth;

  RemoveFriendUsecase(this._fireDatabase, this._fireAuth);

  @override
  Future<void> getRawFuture(String params) async {
    return await _fireDatabase.removeFriend(_fireAuth.getUid());
  }
}
