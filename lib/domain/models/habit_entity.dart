import 'dart:ui' show Color;

import 'package:altitude/common/constant/app_colors.dart';
import 'package:altitude/domain/models/frequency_entity.dart';
import 'package:altitude/domain/models/reminder_entity.dart';

class Habit {
  Habit({
    required this.id,
    required this.habit,
    required this.colorCode,
    required this.score,
    required this.frequency,
    required this.initialDate,
    required this.daysDone,
    this.oldCue,
    this.lastDone,
    this.reminder,
  });

  String id;

  final String habit;
  final int colorCode;
  int score;

  String? oldCue;

  final Frequency frequency;
  Reminder? reminder;

  DateTime? lastDone;
  final DateTime initialDate;
  int daysDone;

  Color get color => AppColors.habitsColor[colorCode];
}
