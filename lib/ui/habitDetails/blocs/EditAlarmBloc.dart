import 'dart:async';
import 'package:altitude/controllers/HabitsControl.dart';
import 'package:altitude/core/bloc/BlocBase.dart';
import 'package:altitude/core/model/Pair.dart';
import 'package:altitude/model/Habit.dart';
import 'package:altitude/ui/habitDetails/enums/ReminderType.dart';
import 'package:altitude/ui/habitDetails/model/ReminderCard.dart';
import 'package:altitude/utils/Color.dart';
import 'package:flutter/material.dart' show Color, BuildContext;

class EditAlarmBloc extends BlocBase {
  EditAlarmBloc(this.habit, this.callback);

  final Habit habit;
  final Function(int) callback;

  Color get habitColor => AppColors.habitsColor[habit.color];

  final List<ReminderCard> reminderCards = [
    ReminderCard(ReminderType.HABIT, "Lembrar do hábito"),
    ReminderCard(ReminderType.CUE, "Lembrar do gatilho")
  ];

  // Reminder Card Type Selected
  StreamController<ReminderType> _reminderCardTypeSelectedStreamController = StreamController();
  Stream<ReminderType> get reminderCardTypeSelectedStream => _reminderCardTypeSelectedStreamController.stream;

  // Suggestion List
  StreamController<List<String>> _suggestionListStreamController = StreamController();
  Stream<List<String>> get suggestionListStream => _suggestionListStreamController.stream;

  @override
  void initialize() {}

  @override
  void dispose() {
    _reminderCardTypeSelectedStreamController.close();
    _suggestionListStreamController.close();
  }

  void switchReminderType(ReminderType type) {
    _reminderCardTypeSelectedStreamController.sink.add(type);
  }

  void save() {}

  void remove() {}
}
