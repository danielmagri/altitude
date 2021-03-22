import 'package:altitude/common/model/Habit.dart';

abstract class ILocalNotification {
  Future<void> addNotification(Habit habit);

  Future<void> removeNotification(int id);

  Future<void> removeAllNotification();
}
