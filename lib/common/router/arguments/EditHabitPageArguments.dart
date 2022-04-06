import 'package:altitude/domain/models/habit_entity.dart';

class EditHabitPageArguments {
  EditHabitPageArguments(this.habit, this.hasCompetition);

  final Habit? habit;
  final bool hasCompetition;
}
