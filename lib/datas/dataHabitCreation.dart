import 'dart:math';
import 'package:habit/utils/Color.dart';
import 'package:habit/objects/Reminder.dart';

class DataHabitCreation {
  static final DataHabitCreation _singleton = new DataHabitCreation._internal();

  int indexColor;
  int icon;
  dynamic frequency;
  List<Reminder> reminders;

  factory DataHabitCreation() {
    return _singleton;
  }

  DataHabitCreation._internal();

  void emptyData() {
    indexColor = Random().nextInt(HabitColors.colors.length);
    icon = 0xe028;
    frequency = null;
    reminders = new List();
  }
}
