enum ReminderType { CUE, HABIT }

extension ReminderTypeExtension on ReminderType {
  int? get value {
    switch (this) {
      case ReminderType.CUE:
        return 1;
      case ReminderType.HABIT:
        return 0;
      default:
        return null;
    }
  }
}
