class DayDone {
  final int done;
  final DateTime dateDone;

  DayDone({this.done, this.dateDone});

  factory DayDone.fromJson(Map<String, dynamic> json) => new DayDone(
      done: json["done"],
      dateDone: DateTime.parse(json["date_done"]));

  Map<String, dynamic> toJson() => {
    "done": done,
    "date_done": '${dateDone.year.toString()}-${dateDone.month.toString().padLeft(2, '0')}-${dateDone.day.toString().padLeft(2, '0')}',
  };
}