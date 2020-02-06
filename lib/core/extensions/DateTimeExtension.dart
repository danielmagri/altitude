import 'package:altitude/utils/Constants.dart';

extension dateTime on DateTime {

  DateTime lastWeekDay() {
    int days = this.weekday == 7 ? LAST_WEEKDAY : LAST_WEEKDAY - this.weekday;
    return this.add(Duration(days: days));
  }

}
