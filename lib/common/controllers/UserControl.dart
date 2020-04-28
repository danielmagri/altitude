import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/services/Database.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/core/services/FireAuth.dart';
import 'package:altitude/core/services/FireFunctions.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/feature/home/model/User.dart';

class UserControl {
  Future<bool> isLogged() async {
    return await FireAuth().isLogged();
  }

  Future<User> getUserData() async {
    String name = await getName();
    String email = await FireAuth().getEmail();
    String imageUrl = await FireAuth().getPhotoUrl();
    int score = SharedPref.instance.score;

    return User(name, email, score, imageUrl);
  }

  Future<String> getUid() async {
    return await FireAuth().getUid();
  }

  Future<String> getName() async {
    String name = await FireAuth().getName();
    return name != "" ? name : SharedPref.instance.name;
  }

  Future<bool> setName(String name) async {
    if (await FireAuth().isLogged()) {
      SharedPref.instance.name = name;
      await FireAuth().setName(name);
      return await FireFunctions().updateUser(await DatabaseService().listCompetitionsIds(), name: name);
    } else {
      SharedPref.instance.name = name;
      return true;
    }
  }

  Future<String> getEmail() async {
    return await FireAuth().getEmail();
  }

  Future<String> getPhotoUrl() async {
    return await FireAuth().getPhotoUrl();
  }

  Future<List<Person>> getFriends() async {
    return await FireFunctions().getFriends();
  }

  Future<List<Person>> getPendingFriends() async {
    return await FireFunctions().getPendingFriends();
  }

  bool getPendingFriendsStatus() {
    return SharedPref.instance.pendingFriends;
  }

  void setPendingFriendsStatus(bool value) {
    SharedPref.instance.pendingFriends = value;
  }

  Future<List<Person>> searchEmail(String email) async {
    if (email != await getEmail())
      return await FireFunctions().searchEmail(email);
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
