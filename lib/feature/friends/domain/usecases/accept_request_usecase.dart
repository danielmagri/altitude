import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_fire_functions.dart';

class AcceptRequestUsecase extends BaseUsecase<String, void> {
  final IFireDatabase _fireDatabase;
  final IFireAuth _fireAuth;
  final IFireAnalytics _fireAnalytics;
  final IFireFunctions _fireFunctions;
  final Memory _memory;

  AcceptRequestUsecase(this._fireDatabase, this._fireAuth, this._fireAnalytics,
      this._memory, this._fireFunctions);

  @override
  Future<void> getRawFuture(String params) async {
    _fireAnalytics.sendFriendResponse(true);
    return _fireDatabase.acceptRequest(_fireAuth.getUid()).then((token) async {
      if (_memory.person != null) {
        _memory.person!.friends!.add(_fireAuth.getUid());
      }
      await _fireFunctions.sendNotification("Pedido de amizade",
          "${_fireAuth.getName()} aceitou seu pedido.", token);
    });
  }
}
