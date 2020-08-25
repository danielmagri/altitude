import 'dart:ui' show Color;

import 'package:altitude/utils/Color.dart';

class Habit {
  int id;
  int score;
  int color;
  String cue;
  String habit;
  DateTime initialDate;
  int daysDone;

  Habit({this.id, this.color, this.cue, this.habit, this.score, this.initialDate, this.daysDone});

  Color get habitColor => AppColors.habitsColor[color];

  factory Habit.fromJson(Map<String, dynamic> json) => new Habit(
      id: json["id"],
      color: json["color"],
      cue: json["cue_text"] == null ? "" : json["cue_text"],
      habit: json["habit_text"],
      score: json["score"],
      initialDate: json.containsKey("initial_date") && json["initial_date"] != null
          ? DateTime.parse(json["initial_date"])
          : null,
      daysDone: json["days_done"]);

  factory Habit.toDomain(Map<String, dynamic> json) => Habit(
      id: json["id"],
      color: json["color"],
      habit: json["habit"],
      score: json["score"],
      initialDate: null,
      daysDone: json["days_done_count"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "color": color,
        "habit": habit,
        "score": score ?? 0,
        "initial_date": initialDate,
        "days_done_count": daysDone ?? 0
      };
}
