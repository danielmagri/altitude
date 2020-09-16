import 'dart:collection';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FireMessaging {

  void configure() {
    FirebaseMessaging().configure(onMessage: (Map<String, dynamic> message) async {
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
      PersonUseCase.getInstance.pendingFriendsStatus = true;
    }
    if (data.containsKey('new_competition')) {
      CompetitionUseCase.getInstance.pendingCompetitionsStatus = true;
    }
  }
}
