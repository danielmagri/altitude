import 'package:altitude/common/shared_pref/shared_pref.dart';
import 'package:altitude/common/useCase/CompetitionUseCase.dart';
import 'package:altitude/common/useCase/PersonUseCase.dart';
import 'package:altitude/core/di/get_it_config.dart';
import 'package:altitude/core/services/interfaces/i_fire_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@service
@Injectable(as: IFireMessaging)
class FireMessaging implements IFireMessaging {
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'Geral', // title
    'Notificações em geral', // description
    importance: Importance.max,
  );

  FireMessaging() {
    FirebaseMessaging.onBackgroundMessage((message) async {
      configureDependencies();

      await GetIt.I.isReady<SharedPref>();

      if (message.data != null) {
        _pendingRequest(message.data);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
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
            ));
      }
    });
  }

  Future<String?> get getToken => FirebaseMessaging.instance.getToken();

  void _pendingRequest(Map<dynamic, dynamic> data) {
    if (data.containsKey('new_friend')) {
      GetIt.I.get<PersonUseCase>().pendingFriendsStatus = true;
    }
    if (data.containsKey('new_competition')) {
      GetIt.I.get<CompetitionUseCase>().pendingCompetitionsStatus = true;
    }
  }
}
