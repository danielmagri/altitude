import 'package:altitude/data/model/habit_model.dart';

abstract class ILocalNotification {
  Future<void> addNotification(HabitModel habit);

  Future<void> removeNotification(int? id);

  Future<void> removeAllNotification();
}
