import 'package:altitude/common/model/Person.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/core/model/Result.dart';
import 'package:altitude/core/services/Database.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/core/services/FireAuth.dart';
import 'package:altitude/core/services/FireDatabase.dart';
import 'package:altitude/core/services/FireFunctions.dart';
import 'package:altitude/core/services/Memory.dart';
import 'package:get_it/get_it.dart';

class PersonUseCase {
  static PersonUseCase get getInstance => GetIt.I.get<PersonUseCase>();

  final Memory _memory = Memory.getInstance;

  bool get isLogged => FireAuth().isLogged();

  String get uid => FireAuth().getUid();

  String get name => FireAuth().getName();

  String get email => FireAuth().getEmail();

  String get photoUrl => FireAuth().getPhotoUrl();

  Future<Result<Person>> getPerson() {
    if (_memory.person == null) {
      return FireDatabase().getPerson().then((data) {
        data.photoUrl = photoUrl;
        _memory.person = data;
        return Result.success(data);
      }).catchError((error) => Result.error(error));
    } else {
      return Future.value(Result.success(_memory.person));
    }
  }

  Future<int> getScore() async {
    return (await getPerson()).result((data) => data.score, (error) => 0);
  }

  void setLocalScore(int score) {
    if (_memory.person != null) {
      _memory.person.score = score;
    }
  }

  Future<Result<void>> updateLevel(int level) {
    return FireDatabase().updateLevel(level).then((value) {
      _memory.person.level = level;
      return Result.success(null);
    }).catchError((error) => Result.error(error));
  }

  //TODO: alterar direto pelo firestore
  Future<bool> setName(String name) async {
    FireAuth().setName(name);
    return await FireFunctions().updateUser(await DatabaseService().listCompetitionsIds(), name: name);
  }

  bool get pendingFriendsStatus => SharedPref.instance.pendingFriends;
  set pendingFriendsStatus(bool value) => SharedPref.instance.pendingFriends = value;

  Future<List<Person>> getFriends() async {
    return await FireFunctions().getFriends();
  }

  Future<List<Person>> getPendingFriends() async {
    return await FireFunctions().getPendingFriends();
  }

  Future<List<Person>> searchEmail(String value) async {
    if (value != email)
      return await FireFunctions().searchEmail(value);
    else
      return List();
  }

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

  Future<List<Person>> rankingFriends() async {
    return await FireFunctions().rankingFriends(3);
  }

  Future<void> logout() async {
    await FireAuth().logout();
  }
}
