import 'dart:ui' show Color;
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/utils/Color.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class Habit {
  String id;
  int oldId;

  String habit;
  int colorCode;
  int score;

  String oldCue;

  Frequency frequency;

  DateTime initialDate;
  int daysDone;

  Habit(
      {this.id,
      this.oldId,
      this.habit,
      this.colorCode,
      this.score,
      this.oldCue,
      this.frequency,
      this.initialDate,
      this.daysDone});

  Color get color => AppColors.habitsColor[colorCode];

  static const ID = "id";
  static const HABIT = "habit";
  static const COLOR = "color";
  static const SCORE = "score";
  static const OLD_CUE = "old_cue";
  static const FREQUENCY = "frequency";
  static const INITIAL_DATE = "initial_date";
  static const DAYS_DONE_COUNT = "days_done_count";

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
      id: json[ID],
      habit: json[HABIT],
      colorCode: json[COLOR],
      score: json[SCORE],
      oldCue: json[OLD_CUE] == null ? "" : json[OLD_CUE],
      frequency: Frequency.fromJson(json[FREQUENCY]),
      initialDate: DateTime.fromMillisecondsSinceEpoch((json[INITIAL_DATE] as Timestamp).millisecondsSinceEpoch),
      daysDone: json[DAYS_DONE_COUNT]);

  factory Habit.fromJsonOld(Map<String, dynamic> json) => new Habit(
      oldId: json["id"],
      colorCode: json["color"],
      oldCue: json["cue_text"] == null ? "" : json["cue_text"],
      habit: json["habit_text"],
      score: json["score"],
      initialDate: json.containsKey("initial_date") && json["initial_date"] != null
          ? DateTime.parse(json["initial_date"])
          : null,
      daysDone: json["days_done"]);

  Map<String, dynamic> toJson() => {
        ID: id,
        HABIT: habit,
        COLOR: colorCode,
        SCORE: score ?? 0,
        OLD_CUE: oldCue,
        FREQUENCY: frequency.toJson(),
        INITIAL_DATE: initialDate,
        DAYS_DONE_COUNT: daysDone ?? 0
      };
}
