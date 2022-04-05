import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/domain/models/person_entity.dart';

class CreateCompetitionPageArguments {
  CreateCompetitionPageArguments(this.habits, this.friends);

  final List<Habit> habits;
  final List<Person> friends;
}
