import 'package:altitude/common/constant/util.dart';
import 'package:altitude/domain/models/habit_entity.dart';

class HistoricStatisticData {
  HistoricStatisticData(this.habitsMap, this.month, this.year, this.firstOfYear)
      : totalScore = habitsMap.isEmpty
            ? 0
            : habitsMap.values.reduce((e1, e2) => e1 + e2);

  final Map<Habit, int> habitsMap;
  final int totalScore;
  final int month;
  final int year;
  final bool firstOfYear;

  String get monthText => Util.getMonthName(month);
}
