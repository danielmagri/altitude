import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/infra/interface/i_fire_messaging.dart';
import 'package:altitude/infra/services/shared_pref/shared_pref.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IFireMessaging)
class FireMessaging implements IFireMessaging {
  FireMessaging() {
    FirebaseMessaging.onBackgroundMessage((message) async {
      await configureDependencies();

      _pendingRequest(message.data);
    });

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
            ),
          ),
        );
      }
    });
  }

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'Geral', // title
    'Notificações em geral', // description
    importance: Importance.max,
  );

  @override
  Future<String?> get getToken => FirebaseMessaging.instance.getToken();

  void _pendingRequest(Map<dynamic, dynamic> data) {
    if (data.containsKey('new_friend')) {
      GetIt.I.get<SharedPref>().pendingFriends = true;
    }
    if (data.containsKey('new_competition')) {
      GetIt.I.get<SharedPref>().pendingCompetition = true;
    }
  }
}
