import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit/utils/Color.dart';
import 'package:habit/objects/Habit.dart';

class NotificationControl {
  static final NotificationControl _singleton = new NotificationControl._internal();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  factory NotificationControl() {
    return _singleton;
  }

  NotificationControl._internal() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid = AndroidInitializationSettings('icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }

  Future<void> addNotification(int id, int hour, int minute, int weekday, Habit habit) async {
    Time time = Time(hour, minute);
    Day day = Day(weekday);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "1", // channel id
      "Aviso do hábito", // channel name
      "Aviso para não esquecer sobre a deixa do hábito", // channel description
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
      color: HabitColors.colors[habit.color],
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        id, habit.cue, "para " + habit.habit.toLowerCase(), day, time, platformChannelSpecifics,
        payload: habit.id.toString());
  }

  Future<void> removeNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
