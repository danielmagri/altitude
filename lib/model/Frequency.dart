class DayWeek extends Frequency {
  int habitId;
  int monday, tuesday, wednesday, thursday, friday, saturday, sunday;

  DayWeek(
      {this.habitId,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday});

  factory DayWeek.fromJson(Map<String, dynamic> json) => new DayWeek(
      habitId: json["habit_id"],
      monday: json["monday"],
      tuesday: json["tuesday"],
      wednesday: json["wednesday"],
      thursday: json["thursday"],
      friday: json["friday"],
      saturday: json["saturday"],
      sunday: json["sunday"]);

  @override
  int daysCount() {
    int days = 0;

    if (monday == 1) days++;
    if (tuesday == 1) days++;
    if (wednesday == 1) days++;
    if (thursday == 1) days++;
    if (friday == 1) days++;
    if (saturday == 1) days++;
    if (sunday == 1) days++;

    return days;
  }

  bool isADoneDay(DateTime day) {
    if (monday == 1 && day.weekday == 1) return true;
    if (tuesday == 1 && day.weekday == 2) return true;
    if (wednesday == 1 && day.weekday == 3) return true;
    if (thursday == 1 && day.weekday == 4) return true;
    if (friday == 1 && day.weekday == 5) return true;
    if (saturday == 1 && day.weekday == 6) return true;
    if (sunday == 1 && day.weekday == 7) return true;

    return false;
  }

  Map<String, dynamic> toJson() => {
        "habit_id": habitId,
        "monday": monday,
        "tuesday": tuesday,
        "wednesday": wednesday,
        "thursday": thursday,
        "friday": friday,
        "saturday": saturday,
        "sunday": sunday,
      };
}

class Weekly extends Frequency {
  int habitId;
  int daysTime;

  Weekly({this.habitId, this.daysTime});

  factory Weekly.fromJson(Map<String, dynamic> json) =>
      new Weekly(habitId: json["habit_id"], daysTime: json["days_time"]);

  Map<String, dynamic> toJson() => {
        "habit_id": habitId,
        "days_time": daysTime,
      };

  @override
  int daysCount() => daysTime;
}

abstract class Frequency {
  int daysCount();
}
