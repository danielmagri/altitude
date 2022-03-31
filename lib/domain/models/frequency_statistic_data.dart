import 'package:altitude/common/model/Habit.dart';
import 'package:altitude/utils/Util.dart';

class FrequencyStatisticData {
  FrequencyStatisticData(this.weekdayDone, this.habitsMap, this.month, this.year, this.firstOfYear);

  final List<int> weekdayDone;
  final Map<Habit, List<int>> habitsMap;
  final int month;
  final int year;
  final bool firstOfYear;

  String get monthText => Util.getMonthName(month);
}