
import 'package:altitude/utils/Util.dart';

class FrequencyStatisticData {
  FrequencyStatisticData(this.weekdayDone, this.month, this.year, this.firstOfYear);

  final List<int> weekdayDone;
  final int month;
  final int year;
  final bool firstOfYear;

  String get monthText => Util.getMonthName(month);
}