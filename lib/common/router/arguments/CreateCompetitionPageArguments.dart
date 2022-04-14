import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/common/model/Person.dart';

class CreateCompetitionPageArguments {
  final List<Habit> habits;
  final List<Person> friends;

  CreateCompetitionPageArguments(this.habits, this.friends);
}
