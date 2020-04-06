import 'package:altitude/common/constant/Constants.dart';

extension dateTime on DateTime {

  /// Retorna a data de hoje, sem as horas
  DateTime get today {
    return DateTime(this.year, this.month, this.day);
  }

  /// Retorna o último dia da semana
  DateTime lastWeekDay() {
    int days = this.weekday == 7 ? LAST_WEEKDAY : LAST_WEEKDAY - this.weekday;
    return this.add(Duration(days: days));
  }

  /// Retorna o último dia do mês anterior
  DateTime lastDayOfPreviousMonth() {
    return DateTime(this.year, this.month, 1).subtract(Duration(days: 1));
  }
}
