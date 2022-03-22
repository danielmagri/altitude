import 'package:altitude/feature/habits/domain/enums/reminder_type.dart';

class ReminderCard {
  ReminderCard(this.type, this.title);

  final ReminderType type;
  final String title;
}
