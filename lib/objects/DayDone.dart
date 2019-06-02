class DayDone {
  final int done;
  final DateTime dateDone;
  final int cycle;
  final int habitId;

  DayDone({this.done, this.dateDone, this.cycle, this.habitId});

  factory DayDone.fromJson(Map<String, dynamic> json) => new DayDone(
      done: json["done"],
      dateDone: json.containsKey("date_done") && json["date_done"] != null ? DateTime.parse(json["date_done"]) : null,
      cycle: json["cycle"],
      habitId: json["habit_id"]);

  Map<String, dynamic> toJson() => {
        "done": done,
        "date_done":
            '${dateDone.year.toString()}-${dateDone.month.toString().padLeft(2, '0')}-${dateDone.day.toString().padLeft(2, '0')}',
        "cycle": cycle,
      };
}
