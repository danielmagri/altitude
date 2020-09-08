import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class DayDone {
  final String habitId;
  final DateTime date;

  DayDone({this.habitId, this.date});

  String get dateFormatted =>
      '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  factory DayDone.fromJson(Map<String, dynamic> json) =>
      DayDone(date: DateTime.fromMillisecondsSinceEpoch((json["date"] as Timestamp).millisecondsSinceEpoch));

  Map<String, dynamic> toJson() => {"date": date};
}
