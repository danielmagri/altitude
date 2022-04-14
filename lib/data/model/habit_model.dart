import 'package:altitude/data/model/frequency_model.dart';
import 'package:altitude/data/model/reminder_model.dart';
import 'package:altitude/domain/models/frequency_entity.dart';
import 'package:altitude/domain/models/habit_entity.dart';
import 'package:altitude/domain/models/reminder_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel extends Habit {
  HabitModel({
    required String id,
    required String habit,
    required int colorCode,
    required Frequency frequency,
    required DateTime initialDate,
    int daysDone = 0,
    int score = 0,
    String? oldCue,
    DateTime? lastDone,
    Reminder? reminder,
  }) : super(
          id: id,
          habit: habit,
          colorCode: colorCode,
          score: score,
          oldCue: oldCue,
          frequency: frequency,
          reminder: reminder,
          lastDone: lastDone,
          initialDate: initialDate,
          daysDone: daysDone,
        );

  factory HabitModel.fromJson(Map<String, dynamic> json) => HabitModel(
        id: json[idTag],
        habit: json[habitTag],
        colorCode: json[colorTag],
        score: json[scoreTag],
        oldCue: json[oldCueTag] ?? '',
        frequency: FrequencyModel.fromJson(json[frequencyTag]),
        reminder: json[reminderTag] != null
            ? ReminderModel.fromJson(json[reminderTag])
            : null,
        lastDone: json[lastDoneTag] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                (json[lastDoneTag] as Timestamp).millisecondsSinceEpoch,
              )
            : null,
        initialDate: DateTime.fromMillisecondsSinceEpoch(
          (json[initialDateTag] as Timestamp).millisecondsSinceEpoch,
        ),
        daysDone: json[daysDoneCountTag],
      );

  factory HabitModel.fromEntity(Habit entity) => HabitModel(
        id: entity.id,
        habit: entity.habit,
        colorCode: entity.colorCode,
        score: entity.score,
        oldCue: entity.oldCue,
        frequency: entity.frequency,
        initialDate: entity.initialDate,
        daysDone: entity.daysDone,
        reminder: entity.reminder,
      );

  static const idTag = 'id';
  static const habitTag = 'habit';
  static const colorTag = 'color';
  static const scoreTag = 'score';
  static const oldCueTag = 'old_cue';
  static const frequencyTag = 'frequency';
  static const reminderTag = 'reminder';
  static const lastDoneTag = 'last_done';
  static const initialDateTag = 'initial_date';
  static const daysDoneCountTag = 'days_done_count';

  Map<String, dynamic> toJson() => {
        idTag: id,
        habitTag: habit,
        colorTag: colorCode,
        scoreTag: score,
        oldCueTag: oldCue,
        frequencyTag: FrequencyModel.fromEntity(frequency).toJson(),
        if (reminder != null)
          reminderTag: ReminderModel.fromEntity(reminder!).toJson(),
        lastDoneTag: lastDone,
        initialDateTag: initialDate,
        daysDoneCountTag: daysDone
      };
}
