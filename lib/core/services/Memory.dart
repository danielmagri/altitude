import 'package:altitude/common/model/Competition.dart';
import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:get_it/get_it.dart';

class Memory {
  static Memory get getI => GetIt.I.get<Memory>();

  Person? person;
  List<Habit> habits = [];
  List<Competition> competitions = [];

  void clear() {
    person = null;
    habits = [];
    competitions = [];
  }
}
