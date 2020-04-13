import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:altitude/utils/Color.dart';

class NotificationControl {
  static final NotificationControl _singleton =
      new NotificationControl._internal();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  factory NotificationControl() {
    return _singleton;
  }

  NotificationControl._internal() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }

  Future<void> addNotification(Reminder reminder, Habit habit) async {
    Time time = Time(reminder.hour, reminder.minute);
    Day day = Day(reminder.weekday);
    String title = reminder.type == 0 ? habit.habit : habit.cue;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "1", // channel id
      "Aviso do hábito", // channel name
      "Aviso para não esquecer sobre o hábito", // channel description
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
      color: AppColors.habitsColor[habit.color],
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        reminder.id, title, "", day, time, platformChannelSpecifics,
        payload: habit.id.toString());
  }

  Future<void> removeNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
