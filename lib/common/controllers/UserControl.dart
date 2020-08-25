import 'package:altitude/common/model/Person.dart';
import 'package:altitude/core/services/Database.dart';
import 'package:altitude/core/services/FireAnalytics.dart';
import 'package:altitude/core/services/FireAuth.dart';
import 'package:altitude/core/services/FireFunctions.dart';
import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/feature/home/model/User.dart';

class UserControl {
  bool isLogged() {
    return FireAuth().isLogged();
  }

  User getUserData() {
    String name = getName();
    String email = FireAuth().getEmail();
    String imageUrl = FireAuth().getPhotoUrl();
    int score = SharedPref.instance.score;

    return User(name, email, score, imageUrl);
  }

  String getUid() {
    return FireAuth().getUid();
  }

  String getName() {
    String name = FireAuth().getName();
    return name != "" ? name : SharedPref.instance.name;
  }

  Future<bool> setName(String name) async {
    if (FireAuth().isLogged()) {
      SharedPref.instance.name = name;
      FireAuth().setName(name);
      return await FireFunctions().updateUser(await DatabaseService().listCompetitionsIds(), name: name);
    } else {
      SharedPref.instance.name = name;
      return true;
    }
  }

  String getEmail() {
    return FireAuth().getEmail();
  }

  String getPhotoUrl() {
    return FireAuth().getPhotoUrl();
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
    if (email != getEmail())
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
