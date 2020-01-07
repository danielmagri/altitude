import 'dart:math';
import 'package:habit/utils/Color.dart';
import 'package:habit/model/Reminder.dart';

class DataHabitCreation {
  static final DataHabitCreation _singleton = new DataHabitCreation._internal();

  int indexColor;
  dynamic frequency;
  List<Reminder> reminders;

  int lastTextEdited = 0; //0 Habit, 1 Cue

  factory DataHabitCreation() {
    return _singleton;
  }

  DataHabitCreation._internal() {
    emptyData();
  }

  void emptyData() {
    indexColor = Random().nextInt(AppColors.habitsColor.length);
    frequency = null;
    reminders = new List();
  }
}
