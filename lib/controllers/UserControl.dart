import 'package:habit/objects/Person.dart';
import 'package:habit/services/Database.dart';
import 'package:habit/services/FireAuth.dart';
import 'package:habit/services/FireFunctions.dart';
import 'package:habit/services/SharedPref.dart';

class UserControl {
  Future<bool> isLogged() async {
    return await FireAuth().isLogged();
  }

  Future<String> getName() async {
    String name = await FireAuth().getName();
    return name != "" ? name : SharedPref().getName();
  }

  Future<bool> setName(String name) async {
    if (await FireAuth().isLogged()) {
      await SharedPref().setName(name);
      await FireAuth().setName(name);
      return await FireFunctions().updateUser(name: name);
    } else {
      return await SharedPref().setName(name);
    }
  }

  Future<int> getScore() async {
    return await SharedPref().getScore();
  }

  Future<bool> setScore(int id, int score) async {
    bool result1 = await SharedPref().setScore(score);
    bool result2 = await DatabaseService().updateScore(id, score);
    FireFunctions().updateUser(score: await SharedPref().getScore());
    return result1 && result2 ? true : false;
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

  Future<List<Person>> searchEmail(String email) async {
    return await FireFunctions().searchEmail(email);
  }

  Future<void> friendRequest(String uid) async {
    return await FireFunctions().friendRequest(uid);
  }

  Future<void> acceptRequest(String uid) async {
    return await FireFunctions().acceptRequest(uid);
  }

  Future<void> declineRequest(String uid) async {
    return await FireFunctions().declineRequest(uid);
  }

  Future<void> cancelFriendRequest(String uid) async {
    return await FireFunctions().cancelFriendRequest(uid);
  }

  Future<void> removeFriend(String uid) async {
    return await FireFunctions().removeFriend(uid);
  }

  Future<void> logout() async {
    await FireAuth().logout();
  }
}
