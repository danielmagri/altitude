import 'package:altitude/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/domain/usecases/user/update_fcm_token_usecase.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/base/base_usecase.dart';
import 'package:altitude/core/model/no_params.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart';

class CreatePersonUsecase extends BaseUsecase<CreatePersonParams, void> {
  final Memory _memory;
  final IFireDatabase _fireDatabase;
  final IFireAuth _fireAuth;
  final IFireMessaging _fireMessaging;
  final GetUserDataUsecase _getUserDataUsecase;
  final UpdateFCMTokenUsecase _updateFCMTokenUsecase;

  CreatePersonUsecase(
      this._memory,
      this._fireDatabase,
      this._fireAuth,
      this._fireMessaging,
      this._getUserDataUsecase,
      this._updateFCMTokenUsecase);

  @override
  Future<void> getRawFuture(CreatePersonParams params) async {
    return (await _getUserDataUsecase(true)).result((data) async {
      _updateFCMTokenUsecase.call(NoParams());
      return;
    }, (error) async {
      Person person = Person(
          name: _fireAuth.getName(),
          email: _fireAuth.getEmail(),
          fcmToken: await _fireMessaging.getToken,
          level: params.level ?? 0,
          reminderCounter: params.reminderCounter ?? 0,
          score: params.score ?? 0,
          friends: params.friends ?? [],
          pendingFriends: params.pendingFriends ?? []);
      await _fireDatabase.createPerson(person);
      person.photoUrl = _fireAuth.getPhotoUrl();
      _memory.person = person;
    });
  }
}

class CreatePersonParams {
  final int? level;
  final int? reminderCounter;
  final int? score;
  final List<String?>? friends;
  final List<String?>? pendingFriends;

  CreatePersonParams(
      {this.level,
      this.reminderCounter,
      this.score,
      this.friends,
      this.pendingFriends});
}
