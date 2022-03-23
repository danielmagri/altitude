import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@usecase
@Injectable()
class CancelFriendRequestUsecase extends BaseUsecase<String, void> {
  final IFireDatabase _fireDatabase;
  final IFireAuth _fireAuth;
  final IFireAnalytics _fireAnalytics;
  final Memory _memory;

  CancelFriendRequestUsecase(
      this._fireDatabase, this._fireAuth, this._fireAnalytics, this._memory);

  @override
  Future<void> getRawFuture(String params) async {
    _fireAnalytics.sendFriendRequest(true);
    return _fireDatabase.cancelFriendRequest(_fireAuth.getUid()).then((value) {
      if (_memory.person != null) {
        _memory.person!.pendingFriends!.remove(_fireAuth.getUid());
      }
    });
  }
}
