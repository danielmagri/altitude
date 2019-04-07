import 'dart:async';
import 'package:habit/services/Database.dart';
import 'package:habit/objects/Habit.dart';

class DataControl {

  Future<List<Habit>> getHabitsToday() async {
    return await DatabaseService().getHabitsToday();
  }

  Future<Habit> getHabit(int id) async {
    return await DatabaseService().getHabit(id);
  }

  Future<bool> habitDone(int id) async {
    return await DatabaseService().habitDone(id);
  }

  Future<bool> addHabit(Habit habit) async {
    return await DatabaseService().addHabit(habit);
  }
}
