import 'package:altitude/common/domain/usecases/user/get_user_data_usecase.dart';
import 'package:altitude/common/domain/usecases/user/update_fcm_token_usecase.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/shared_pref/shared_pref.dart';
import 'package:altitude/core/base/BaseUseCase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/model/result.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:altitude/core/services/interfaces/i_fire_analytics.dart';
import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:altitude/core/services/interfaces/i_fire_database.dart';
import 'package:altitude/core/services/interfaces/i_fire_functions.dart';
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@deprecated
@usecase
@Injectable()
class PersonUseCase extends BaseUseCase {
  static PersonUseCase get getI => GetIt.I.get<PersonUseCase>();

  final Memory _memory;
  final IFireAuth _fireAuth;
  final IFireMessaging _fireMessaging;
  final IFireDatabase _fireDatabase;
  final IFireAnalytics _fireAnalytics;
  final IFireFunctions _fireFunctions;
  final GetUserDataUsecase _getUserDataUsecase;
  final UpdateFCMTokenUsecase _updateFCMTokenUsecase;

  PersonUseCase(
      this._memory,
      this._fireAuth,
      this._fireMessaging,
      this._fireDatabase,
      this._fireAnalytics,
      this._fireFunctions,
      this._getUserDataUsecase,
      this._updateFCMTokenUsecase);

  bool get isLogged => _fireAuth.isLogged();

  String get uid => _fireAuth.getUid();

  String? get name => _fireAuth.getName();

  String? get email => _fireAuth.getEmail();

  String? get photoUrl => _fireAuth.getPhotoUrl();

  Future<String?> get fcmToken => _fireMessaging.getToken;

  Future<Result> createPerson(
          {int? level,
          int? reminderCounter,
          int? score,
          List<String?>? friends,
          List<String?>? pendingFriends}) =>
      safeCall(() async {
        return (await _getUserDataUsecase(true)).result((data) async {
          _updateFCMTokenUsecase();
          return;
        }, (error) async {
          Person person = Person(
              name: name,
              email: email,
              fcmToken: await fcmToken,
              level: level ?? 0,
              reminderCounter: reminderCounter ?? 0,
              score: score ?? 0,
              friends: friends ?? [],
              pendingFriends: pendingFriends ?? []);
          await _fireDatabase.createPerson(person);
          person.photoUrl = photoUrl;
          _memory.person = person;
        });
      });

  Future<int?> getScore() async {
    return (await _getUserDataUsecase(false)).absoluteResult().score;
  }

  void setLocalScore(int score) {
    if (_memory.person != null) {
      _memory.person!.score = score;
    }
  }

  Future<Result<void>> updateLevel(int level) => safeCall(() async {
        await _fireDatabase.updateLevel(level);
        _memory.person!.level = level;
        return;
      });

  Future<Result> updateName(String name, List<String?> competitionsId) =>
      safeCall(() async {
        await _fireAuth.setName(name);
        await _fireDatabase.updateName(name, competitionsId);
        _memory.person?.name = name;
        return;
      });

  bool get pendingFriendsStatus => SharedPref.instance.pendingFriends;
  set pendingFriendsStatus(bool value) =>
      SharedPref.instance.pendingFriends = value;

  Future<Result<List<Person>>> getPendingFriends() => safeCall(() async {
        return await _fireDatabase.getPendingFriends();
      });

  Future<Result<List<Person>>> searchEmail(String value) => safeCall(() async {
        if (value != email) {
          List<String?> myPendingFriends =
              (await _getUserDataUsecase(false)).absoluteResult().pendingFriends ??
                  [];
          return await _fireDatabase.searchEmail(value, myPendingFriends);
        } else {
          return [];
        }
      });

  Future<Result> friendRequest(String? uid) => safeCall(() async {
        _fireAnalytics.sendFriendRequest(false);
        return _fireDatabase.friendRequest(uid).then((token) async {
          if (_memory.person != null) {
            _memory.person!.pendingFriends!.add(uid);
          }
          await _fireFunctions.sendNotification(
              "Pedido de amizade", "$name quer ser seu amigo.", token);
        });
      });

  Future<Result> acceptRequest(String? uid) => safeCall(() async {
        _fireAnalytics.sendFriendResponse(true);
        return _fireDatabase.acceptRequest(uid).then((token) async {
          if (_memory.person != null) {
            _memory.person!.friends!.add(uid);
          }
          await _fireFunctions.sendNotification(
              "Pedido de amizade", "$name aceitou seu pedido.", token);
        });
      });

  Future<Result> declineRequest(String? uid) => safeCall(() async {
        _fireAnalytics.sendFriendResponse(false);
        return await _fireDatabase.declineRequest(uid);
      });

  Future<Result> cancelFriendRequest(String? uid) => safeCall(() async {
        _fireAnalytics.sendFriendRequest(true);
        return _fireDatabase.cancelFriendRequest(uid).then((value) {
          if (_memory.person != null) {
            _memory.person!.pendingFriends!.remove(uid);
          }
        });
      });

  Future<Result> removeFriend(String? uid) => safeCall(() async {
        return await _fireDatabase.removeFriend(uid);
      });

  Future logout() async {
    _memory.clear();
    await _fireAuth.logout();
  }
}
