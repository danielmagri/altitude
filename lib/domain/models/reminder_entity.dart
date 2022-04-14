import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Reminder {
  Reminder({
    required this.type,
    required this.hour,
    required this.minute,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    this.id,
  });

  int? id;
  final int type; // 0-Habit 1-Cue

  final int hour;
  final int minute;

  bool monday, tuesday, wednesday, thursday, friday, saturday, sunday;

  List<Day> getAllweekdays() {
    List<Day> days = [];
    if (monday) days.add(Day.monday);
    if (tuesday) days.add(Day.tuesday);
    if (wednesday) days.add(Day.wednesday);
    if (thursday) days.add(Day.thursday);
    if (friday) days.add(Day.friday);
    if (saturday) days.add(Day.saturday);
    if (sunday) days.add(Day.sunday);

    return days;
  }

  List<int> getAllweekdaysDateTime() {
    List<int> days = [];
    if (monday) days.add(DateTime.monday);
    if (tuesday) days.add(DateTime.tuesday);
    if (wednesday) days.add(DateTime.wednesday);
    if (thursday) days.add(DateTime.thursday);
    if (friday) days.add(DateTime.friday);
    if (saturday) days.add(DateTime.saturday);
    if (sunday) days.add(DateTime.sunday);

    return days;
  }

  bool hasAnyDay() {
    return monday ||
        tuesday ||
        wednesday ||
        thursday ||
        friday ||
        saturday ||
        sunday;
  }
}
