import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/utils/Util.dart';

class HistoricStatisticData {
  HistoricStatisticData(this.habitsMap, this.month, this.year, this.firstOfYear)
      : totalScore = habitsMap.length == 0 ? 0 : habitsMap.values.reduce((e1, e2) => e1 + e2);

  final Map<Habit, int> habitsMap;
  final int totalScore;
  final int month;
  final int year;
  final bool firstOfYear;

  String get monthText => Util.getMonthName(month);
}
