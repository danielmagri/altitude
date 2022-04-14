enum ReminderType { cue, habit }

extension ReminderTypeExtension on ReminderType {
  int get value {
    switch (this) {
      case ReminderType.cue:
        return 1;
      case ReminderType.habit:
        return 0;
    }
  }
}
