import 'dart:async';
import 'package:habit/services/Database.dart';
import 'package:habit/objects/Habit.dart';

class DataControl {
  Future<List<Habit>> getAllHabits() async {
    return await DatabaseService().getAllHabits();
  }

  Future<Habit> getHabit(int id) async {
    return await DatabaseService().getHabit(id);
  }

  Future<List<Habit>> getHabitsToday() async {
    return await DatabaseService().getHabitsToday();
  }

  Future<bool> habitDone(int id) async {
    return await DatabaseService().habitDone(id);
  }

  Future<bool> addHabit(Habit habit, dynamic frequency) async {
    return await DatabaseService().addHabit(habit, frequency);
  }
}
