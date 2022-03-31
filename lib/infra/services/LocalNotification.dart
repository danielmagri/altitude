import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/infra/interface/i_local_notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:altitude/common/constant/app_colors.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'FireMenssaging.dart';

@Singleton(as: ILocalNotification)
class LocalNotification implements ILocalNotification {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @factoryMethod
  static Future<LocalNotification> initialize() async {
    LocalNotification instance = LocalNotification();
    instance.flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await instance.flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: onSelectNotification);

    // FirebaseMessaging configuration
    await instance.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(FireMessaging.channel);

    return instance;
  }

  static Future onSelectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }

  Future<void> addNotification(Habit habit) async {
    Time time = Time(habit.reminder!.hour!, habit.reminder!.minute!);
    String? title = habit.reminder!.type == 0 ? habit.habit : habit.oldCue;

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "1", // channel id
      "Aviso do hábito", // channel name
      "Aviso para não esquecer sobre o hábito", // channel description
      importance: Importance.max,
      priority: Priority.high,
      color: AppColors.habitsColor[habit.colorCode!],
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    tz.initializeTimeZones();
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    for (int day in habit.reminder!.getAllweekdaysDateTime()) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          habit.reminder!.id!,
          title,
          null,
          _scheduleWeekly(now, day, time),
          platformChannelSpecifics,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: habit.id.toString());
    }

    return;
  }

  tz.TZDateTime _scheduleWeekly(tz.TZDateTime now, int day, Time time) {
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> removeNotification(int? id) async {
    return await flutterLocalNotificationsPlugin.cancel(id!);
  }

  Future<void> removeAllNotification() async {
    return await flutterLocalNotificationsPlugin.cancelAll();
  }
}
