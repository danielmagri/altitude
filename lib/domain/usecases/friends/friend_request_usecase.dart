import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_fire_functions.dart';
import 'package:injectable/injectable.dart';

@injectable
class FriendRequestUsecase extends BaseUsecase<String, void> {
  final IFireDatabase _fireDatabase;
  final IFireAuth _fireAuth;
  final IFireAnalytics _fireAnalytics;
  final Memory _memory;
  final IFireFunctions _fireFunctions;

  FriendRequestUsecase(this._fireDatabase, this._fireAuth, this._fireAnalytics,
      this._memory, this._fireFunctions);

  @override
  Future<void> getRawFuture(String params) async {
    _fireAnalytics.sendFriendRequest(false);
    return _fireDatabase.friendRequest(_fireAuth.getUid()).then((token) async {
      if (_memory.person != null) {
        _memory.person!.pendingFriends!.add(_fireAuth.getUid());
      }
      await _fireFunctions.sendNotification("Pedido de amizade",
          "${_fireAuth.getName()} quer ser seu amigo.", token);
    });
  }
}
