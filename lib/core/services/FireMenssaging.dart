import 'dart:collection';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@service
@Injectable(as: IFireMessaging)
class FireMessaging implements IFireMessaging {
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

  Future<String> get getToken => FirebaseMessaging().getToken();

  void isNewFriendRequest(Map<dynamic, dynamic> data) {
    if (data.containsKey('new_friend')) {
      GetIt.I.get<PersonUseCase>().pendingFriendsStatus = true;
    }
    if (data.containsKey('new_competition')) {
      GetIt.I.get<CompetitionUseCase>().pendingCompetitionsStatus = true;
    }
  }
}
