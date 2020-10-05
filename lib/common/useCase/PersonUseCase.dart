import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/core/base/BaseUseCase.dart';
import 'package:altitude/core/model/Result.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/core/services/FireAuth.dart';
import 'package:altitude/core/services/FireDatabase.dart';
import 'package:altitude/core/services/FireFunctions.dart';
import 'package:altitude/core/services/FireMenssaging.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:get_it/get_it.dart';

class PersonUseCase extends BaseUseCase {
  static PersonUseCase get getInstance => GetIt.I.get<PersonUseCase>();

  final Memory _memory = Memory.getInstance;

  bool get isLogged => FireAuth().isLogged();

  String get uid => FireAuth().getUid();

  String get name => FireAuth().getName();

  String get email => FireAuth().getEmail();

  String get photoUrl => FireAuth().getPhotoUrl();

  Future<String> get fcmToken => FireMessaging().getToken();

  Future<Result> createPerson(
          {int level, int reminderCounter, int score, List<String> friends, List<String> pendingFriends}) =>
      safeCall(() async {
        return (await getPerson(fromServer: true)).result((data) {
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
          await FireDatabase().createPerson(person);
          person.photoUrl = photoUrl;
          _memory.person = person;
        });
      });

  Future<Result<Person>> getPerson({bool fromServer = false}) => safeCall(() async {
        if (_memory.person == null || fromServer) {
          var data = await FireDatabase().getPerson();
          data.photoUrl = photoUrl;
          _memory.person = data;
          return data;
        } else {
          return Future.value(_memory.person);
        }
      });

  Future<int> getScore() async {
    return (await getPerson()).absoluteResult().score;
  }

  void setLocalScore(int score) {
    if (_memory.person != null) {
      _memory.person.score = score;
    }
  }

  Future<Result<void>> updateLevel(int level) => safeCall(() async {
        await FireDatabase().updateLevel(level);
        _memory.person.level = level;
        return;
      });

  Future<Result> updateName(String name, List<String> competitionsId) => safeCall(() async {
        await FireAuth().setName(name);
        await FireDatabase().updateName(name, competitionsId);
        _memory.person?.name = name;
        return;
      });

  bool get pendingFriendsStatus => SharedPref.instance.pendingFriends;
  set pendingFriendsStatus(bool value) => SharedPref.instance.pendingFriends = value;

  Future<Result<List<Person>>> getFriends() => safeCall(() async {
        List<Person> friends = await FireDatabase().getFriendsDetails();
        return friends;
      });

  Future<List<Person>> getPendingFriends() async {
    return await FireFunctions().getPendingFriends();
  }

  Future<Result<List<Person>>> searchEmail(String value) => safeCall(() async {
        if (value != email) {
          List<String> myPendingFriends = (await getPerson()).absoluteResult().pendingFriends ?? List();
          return await FireDatabase().searchEmail(value, myPendingFriends);
        } else {
          return List();
        }
      });

  Future<void> friendRequest(String uid) async {
    FireAnalytics().sendFriendRequest(false);
    return await FireFunctions().friendRequest(uid);
  }

  Future<void> acceptRequest(String uid) async {
    FireAnalytics().sendFriendResponse(true);
    return await FireFunctions().acceptRequest(uid);
  }

  Future<void> declineRequest(String uid) async {
    FireAnalytics().sendFriendResponse(false);
    return await FireFunctions().declineRequest(uid);
  }

  Future<void> cancelFriendRequest(String uid) async {
    FireAnalytics().sendFriendRequest(true);
    return await FireFunctions().cancelFriendRequest(uid);
  }

  Future<void> removeFriend(String uid) async {
    return await FireFunctions().removeFriend(uid);
  }

  Future<Result<List<Person>>> rankingFriends() => safeCall(() async {
        return await FireDatabase().getRankingFriends(3);
      });

  Future<void> logout() async {
    _memory.clear();
    await FireAuth().logout();
  }
}
