import 'dart:ui' show Color;
import 'package:altitude/common/model/Frequency.dart';
import 'package:altitude/common/model/Reminder.dart';
import 'package:altitude/common/constant/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class Habit {
  String? id;
  int? oldId;

  String? habit;
  int? colorCode;
  int? score;

  String? oldCue;

  Frequency? frequency;
  Reminder? reminder;

  DateTime? lastDone;
  DateTime? initialDate;
  int? daysDone;

  Habit({
    this.id,
    this.oldId,
    this.habit,
    this.colorCode,
    this.score,
    this.oldCue,
    this.frequency,
    this.reminder,
    this.lastDone,
    this.initialDate,
    this.daysDone,
  });

  Color get color => AppColors.habitsColor[colorCode!];

  static const ID = 'id';
  static const HABIT = 'habit';
  static const COLOR = 'color';
  static const SCORE = 'score';
  static const OLD_CUE = 'old_cue';
  static const FREQUENCY = 'frequency';
  static const REMINDER = 'reminder';
  static const LAST_DONE = 'last_done';
  static const INITIAL_DATE = 'initial_date';
  static const DAYS_DONE_COUNT = 'days_done_count';

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
      id: json[ID],
      habit: json[HABIT],
      colorCode: json[COLOR],
      score: json[SCORE],
      oldCue: json[OLD_CUE] ?? '',
      frequency: Frequency.fromJson(json[FREQUENCY]),
      reminder:
          json[REMINDER] != null ? Reminder.fromJson(json[REMINDER]) : null,
      lastDone: json[LAST_DONE] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json[LAST_DONE] as Timestamp).millisecondsSinceEpoch)
          : null,
      initialDate: json.containsKey(INITIAL_DATE)
          ? DateTime.fromMillisecondsSinceEpoch(
              (json[INITIAL_DATE] as Timestamp).millisecondsSinceEpoch)
          : null,
      daysDone: json[DAYS_DONE_COUNT]);

  factory Habit.fromDB(Map<String, dynamic> json) => Habit(
      oldId: json['id'],
      colorCode: json['color'],
      score: json['score'],
      habit: json['habit_text'],
      oldCue: json['cue_text'] ?? '',
      initialDate:
          json.containsKey('initial_date') && json['initial_date'] != null
              ? DateTime.parse(json['initial_date'])
              : null,
      daysDone: json['days_done']);

  Map<String, dynamic> toJson() => {
        ID: id,
        HABIT: habit,
        COLOR: colorCode,
        SCORE: score ?? 0,
        OLD_CUE: oldCue ?? '',
        FREQUENCY: frequency?.toJson(),
        REMINDER: reminder?.toJson(),
        LAST_DONE: lastDone,
        INITIAL_DATE: initialDate,
        DAYS_DONE_COUNT: daysDone ?? 0
      };
}
