import 'dart:async';
import 'package:habit/services/Database.dart';
import 'package:habit/objects/Habit.dart';
import 'package:habit/objects/Person.dart';
import 'package:habit/objects/DayDone.dart';

class DataControl {
  static final DataControl _singleton = new DataControl._internal();

  factory DataControl() {
    return _singleton;
  }

  DataControl._internal();

  Future<Person> getPerson() async {
    return await DatabaseService().getPerson();
  }

  Future<List<Habit>> getAllHabits() async {
    return await DatabaseService().getAllHabits();
  }

  Future<Habit> getHabit(int id) async {
    return await DatabaseService().getHabit(id);
  }

  Future<List<Habit>> getHabitsToday() async {
    return await DatabaseService().getHabitsToday();
  }
  
  Future<dynamic> getFrequency(int id) async {
    return await DatabaseService().getFrequency(id);
  }

  Future<Map<DateTime, List>> getDaysDone(int id) async {
    Map<DateTime, List> map = new Map();
    List<DayDone> list = await DatabaseService().getDaysDone(id);

    for(DayDone day in list) {
      map.putIfAbsent(day.dateDone, ()=> ['']);
    }
    return map;
  }

  Future<bool> habitDone(int id) async {
    return await DatabaseService().habitDone(id);
  }

  Future<bool> addHabit(Habit habit, dynamic frequency) async {
    return await DatabaseService().addHabit(habit, frequency);
  }
}
