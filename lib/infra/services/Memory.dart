import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/domain/models/competition_entity.dart';
import 'package:altitude/domain/models/habit_entity.dart';
import 'package:altitude/domain/models/person_entity.dart';
import 'package:injectable/injectable.dart';

@singleton
class Memory {
  static Memory get getI => serviceLocator.get<Memory>();

  Person? person;
  List<Habit> habits = [];
  List<Competition> competitions = [];

  void clear() {
    person = null;
    habits = [];
    competitions = [];
  }
}
