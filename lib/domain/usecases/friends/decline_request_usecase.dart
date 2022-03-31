import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/infra/interface/i_fire_analytics.dart';
import 'package:altitude/infra/interface/i_fire_auth.dart';
import 'package:altitude/infra/interface/i_fire_database.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeclineRequestUsecase extends BaseUsecase<String, void> {
  final IFireDatabase _fireDatabase;
  final IFireAuth _fireAuth;
  final IFireAnalytics _fireAnalytics;

  DeclineRequestUsecase(
      this._fireDatabase, this._fireAuth, this._fireAnalytics);

  @override
  Future<void> getRawFuture(String params) async {
    _fireAnalytics.sendFriendResponse(false);
    return await _fireDatabase.declineRequest(_fireAuth.getUid());
  }
}
