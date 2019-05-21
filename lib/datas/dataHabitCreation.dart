import 'package:habit/objects/Progress.dart';
import 'package:habit/utils/enums.dart';

class DataHabitCreation {
  static final DataHabitCreation _singleton = new DataHabitCreation._internal();

  Progress progress;
  int icon;
  dynamic frequency;

  factory DataHabitCreation() {
    return _singleton;
  }

  DataHabitCreation._internal();

  void emptyData() {
    progress = new Progress(type: ProgressEnum.INFINITY, goal: 0, progress: 0);
    icon = 0xe028;
    frequency = null;
  }
}