class Reminder {
  final int id;
  final int hour;
  final int minute;
  final int weekday;
  final int habitId;

  Reminder({this.id, this.hour, this.minute, this.weekday, this.habitId});

  factory Reminder.fromJson(Map<String, dynamic> json) => new Reminder(
      id: json["id"], hour: json["hour"], minute: json["minute"], weekday: json["weekday"], habitId: json["habit_id"]);
}
