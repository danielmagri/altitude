import 'package:habit/objects/Habit.dart';

class Person {
  static final Person _singleton = new Person._internal();

  String name;
  int score;
  List<Habit> habits;

  factory Person() {
    return _singleton;
  }

  Person._internal() {
    habits = new List();
  }
}