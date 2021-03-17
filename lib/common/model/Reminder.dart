import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Reminder {
  int id;
  final int type; // 0-Habit 1-Cue

  final int hour;
  final int minute;

  bool monday, tuesday, wednesday, thursday, friday, saturday, sunday;

  Reminder(
      {this.id,
      this.type,
      this.hour,
      this.minute,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday});

  List<Day> getAllweekdays() {
    List<Day> days = [];
    if (monday) days.add(Day.Monday);
    if (tuesday) days.add(Day.Tuesday);
    if (wednesday) days.add(Day.Wednesday);
    if (thursday) days.add(Day.Thursday);
    if (friday) days.add(Day.Friday);
    if (saturday) days.add(Day.Saturday);
    if (sunday) days.add(Day.Sunday);

    return days;
  }

  bool hasAnyDay() {
    return monday || tuesday || wednesday || thursday || friday || saturday || sunday;
  }

  static const ID = "id";
  static const TYPE = "type";
  static const HOUR = "hour";
  static const MINUTE = "minute";
  static const MONDAY = "monday";
  static const TUESDAY = "tuesday";
  static const WEDNESDAY = "wednesday";
  static const THURSDAY = "thursday";
  static const FRIDAY = "friday";
  static const SATURDAY = "saturday";
  static const SUNDAY = "sunday";

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
      id: json[ID],
      type: json[TYPE],
      hour: json[HOUR],
      minute: json[MINUTE],
      monday: json[MONDAY],
      tuesday: json[TUESDAY],
      wednesday: json[WEDNESDAY],
      thursday: json[THURSDAY],
      friday: json[FRIDAY],
      saturday: json[SATURDAY],
      sunday: json[SUNDAY]);

  Map<String, dynamic> toJson() => {
        ID: id,
        TYPE: type,
        HOUR: hour,
        MINUTE: minute,
        MONDAY: monday,
        TUESDAY: tuesday,
        WEDNESDAY: wednesday,
        THURSDAY: thursday,
        FRIDAY: friday,
        SATURDAY: saturday,
        SUNDAY: sunday,
      };
}
