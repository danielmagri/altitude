class Reminder {
  final int id;
  final int type; // 0-Habit 1-Cue
  final int hour;
  final int minute;
  final int weekday; // 1-D 2-S 3-T 4-Q 5-Q 6-S 7-S
  final int habitId;

  Reminder(
      {this.id, this.type, this.hour, this.minute, this.weekday, this.habitId});

  factory Reminder.fromJson(Map<String, dynamic> json) => new Reminder(
      id: json["id"],
      type: json["type"],
      hour: json["hour"],
      minute: json["minute"],
      weekday: json["weekday"],
      habitId: json["habit_id"]);
}
