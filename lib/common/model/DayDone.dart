class DayDone {
  final DateTime dateDone;
  final int habitId;

  DayDone({this.dateDone, this.habitId});

  factory DayDone.fromJson(Map<String, dynamic> json) => new DayDone(
      dateDone: json.containsKey("date_done") && json["date_done"] != null
          ? DateTime.parse(json["date_done"])
          : null,
      habitId: json["habit_id"]);

  Map<String, dynamic> toJson() => {
        "date_done":
            '${dateDone.year.toString()}-${dateDone.month.toString().padLeft(2, '0')}-${dateDone.day.toString().padLeft(2, '0')}'
      };
}
