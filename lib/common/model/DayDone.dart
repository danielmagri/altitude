import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:altitude/core/extensions/DateTimeExtension.dart';

class DayDone {
  final String? habitId;
  final DateTime? date;

  DayDone({this.habitId, this.date});

  String get dateFormatted => date!.dateFormatted;

  static const DATE = "date";

  factory DayDone.fromJson(Map<String, dynamic> json) =>
      DayDone(date: DateTime.fromMillisecondsSinceEpoch((json[DATE] as Timestamp).millisecondsSinceEpoch));

  factory DayDone.fromDB(Map<String, dynamic> json) => DayDone(
      date: json.containsKey("date_done") && json["date_done"] != null ? DateTime.parse(json["date_done"]) : null);

  Map<String, dynamic> toJson() => {DATE: date};
}
