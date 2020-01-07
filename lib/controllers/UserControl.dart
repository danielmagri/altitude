import 'package:habit/model/Person.dart';
import 'package:habit/services/Database.dart';
import 'package:habit/services/FireAnalytics.dart';
import 'package:habit/services/FireAuth.dart';
import 'package:habit/services/FireFunctions.dart';
import 'package:habit/services/SharedPref.dart';

class UserControl {
  Future<bool> isLogged() async {
    return await FireAuth().isLogged();
  }

  Future<String> getUid() async {
    return await FireAuth().getUid();
  }

  Future<String> getName() async {
    String name = await FireAuth().getName();
    return name != "" ? name : SharedPref().getName();
  }

  Future<bool> setName(String name) async {
    if (await FireAuth().isLogged()) {
      await SharedPref().setName(name);
      await FireAuth().setName(name);
      return await FireFunctions()
          .updateUser(await DatabaseService().listCompetitionsIds(), name: name);
    } else {
      return await SharedPref().setName(name);
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

  Future<bool> getPendingFriendsStatus() async {
    return await SharedPref().getPendingFriends();
  }

  Future<void> setPendingFriendsStatus(bool value) async {
    return await SharedPref().setPendingFriends(value);
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

  Future<void> logout() async {
    await FireAuth().logout();
  }
}
