import 'package:altitude/common/model/Habit.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:altitude/utils/Color.dart';

class LocalNotification {
  static final LocalNotification _singleton = LocalNotification._internal();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  factory LocalNotification() {
    return _singleton;
  }

  LocalNotification._internal() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid = AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }

  Future<void> addNotification(Habit habit) async {
    Time time = Time(habit.reminder.hour, habit.reminder.minute);
    String title = habit.reminder.type == 0 ? habit.habit : habit.oldCue;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "1", // channel id
      "Aviso do hábito", // channel name
      "Aviso para não esquecer sobre o hábito", // channel description
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
      color: AppColors.habitsColor[habit.colorCode],
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    for (Day day in habit.reminder.getAllweekdays()) {
      await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
          habit.reminder.id, title, "", day, time, platformChannelSpecifics,
          payload: habit.id.toString());
    }

    return;
  }

  Future<void> removeNotification(int id) async {
    return await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> removeAllNotification() async {
    return await flutterLocalNotificationsPlugin.cancelAll();
  }
}
