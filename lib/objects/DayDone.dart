class DayDone {
  final int done;
  final DateTime dateDone;
  final int cycle;

  DayDone({this.done, this.dateDone, this.cycle});

  factory DayDone.fromJson(Map<String, dynamic> json) =>
      new DayDone(done: json["done"], dateDone: DateTime.parse(json["date_done"]), cycle: json["cycle"]);

  Map<String, dynamic> toJson() => {
        "done": done,
        "date_done":
            '${dateDone.year.toString()}-${dateDone.month.toString().padLeft(2, '0')}-${dateDone.day.toString().padLeft(2, '0')}',
        "cycle": cycle,
      };
}
