import 'package:altitude/common/domain/usecases/user/update_fcm_token_usecase.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/base/base_usecase.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart';

class GetUserDataUsecase extends BaseUsecase<bool, Person> {
  final Memory _memory;
  final IFireDatabase _fireDatabase;
  final IFireAuth _fireAuth;
  final IFireMessaging _fireMessaging;
  final UpdateFCMTokenUsecase _updateFCMTokenUsecase;

  GetUserDataUsecase(this._memory, this._fireDatabase, this._fireAuth,
      this._fireMessaging, this._updateFCMTokenUsecase);

  @override
  Future<Person> getRawFuture(bool params) async {
    if (_memory.person == null || params) {
      var data = await _fireDatabase.getPerson();
      data.photoUrl = _fireAuth.getPhotoUrl() ?? "";
      _memory.person = data;

      if (data.fcmToken != await _fireMessaging.getToken) {
        _updateFCMTokenUsecase.call();
      }

      return data;
    } else {
      return Future.value(_memory.person);
    }
  }
}
