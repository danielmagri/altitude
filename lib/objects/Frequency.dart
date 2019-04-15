class FreqDayWeek {
  int habitId;
  int monday, tuesday, wednesday, thursday, friday, saturday, sunday;

  FreqDayWeek(
      {this.habitId,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday});

  factory FreqDayWeek.fromJson(Map<String, dynamic> json) => new FreqDayWeek(
      habitId: json["habit_id"],
      monday: json["monday"],
      tuesday: json["tuesday"],
      wednesday: json["wednesday"],
      thursday: json["thursday"],
      friday: json["friday"],
      saturday: json["saturday"],
      sunday: json["sunday"]);

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

class FreqWeekly {
  int habitId;
  int daysTime;

  FreqWeekly({this.habitId, this.daysTime});

  factory FreqWeekly.fromJson(Map<String, dynamic> json) =>
      new FreqWeekly(habitId: json["habit_id"], daysTime: json["days_time"]);

  Map<String, dynamic> toJson() => {
        "habit_id": habitId,
        "days_time": daysTime,
      };
}

class FreqRepeating {
  int habitId;
  int daysTime, daysCicle;

  FreqRepeating({this.habitId, this.daysTime, this.daysCicle});

  factory FreqRepeating.fromJson(Map<String, dynamic> json) =>
      new FreqRepeating(habitId: json["habit_id"], daysTime: json["days_time"], daysCicle: json["days_cicle"]);

  Map<String, dynamic> toJson() => {
        "habit_id": habitId,
        "days_time": daysTime,
        "days_cicle": daysCicle,
      };
}
