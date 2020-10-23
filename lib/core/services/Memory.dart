import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:get_it/get_it.dart';

class Memory {
  static Memory get getInstance => GetIt.I.get<Memory>();

  Person person;
  List<Habit> habits = List();
  List<Competition> competitions = List();

  void clear() {
    person = null;
    habits = List();
    competitions = List();
  }
}
