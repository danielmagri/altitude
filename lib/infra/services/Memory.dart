import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';
import 'package:altitude/domain/models/competition_entity.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@singleton
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
