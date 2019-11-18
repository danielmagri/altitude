import 'dart:collection';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:habit/controllers/CompetitionsControl.dart';
import 'package:habit/controllers/UserControl.dart';

class FireMessaging {
  void configure() {
    FirebaseMessaging().configure(
        onMessage: (Map<String, dynamic> message) async {
      if (message.containsKey('data')) {
        final LinkedHashMap<dynamic, dynamic> data = message['data'];
        isNewFriendRequest(data);
      }
    }, onLaunch: (Map<String, dynamic> message) async {
      if (message.containsKey('data')) {
        final LinkedHashMap<dynamic, dynamic> data = message['data'];
        isNewFriendRequest(data);
      }
    }, onResume: (Map<String, dynamic> message) async {
      if (message.containsKey('data')) {
        final LinkedHashMap<dynamic, dynamic> data = message['data'];
        isNewFriendRequest(data);
      }
    });
  }

  Future<String> getToken() async {
    return await FirebaseMessaging().getToken();
  }

  void isNewFriendRequest(Map<dynamic, dynamic> data) {
    if (data.containsKey('new_friend')) {
      UserControl().setPendingFriendsStatus(true);
    }
    if (data.containsKey('new_competition')) {
      CompetitionsControl().setPendingCompetitionsStatus(true);
    }
  }
}
