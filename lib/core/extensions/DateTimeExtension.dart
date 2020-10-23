import 'package:altitude/common/constant/Constants.dart';

extension dateTime on DateTime {

  /// Retorna a data de hoje, sem as horas
  DateTime get today {
    return DateTime(this.year, this.month, this.day);
  }

  String get dateFormatted {
    return '${this.year.toString()}-${this.month.toString().padLeft(2, '0')}-${this.day.toString().padLeft(2, '0')}';
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

  bool isAfterOrSameDay(DateTime day2) {
    return day2 != null && (this.isAfter(day2) || this.isSameDay(day2));
  }

  bool isBeforeOrSameDay(DateTime day2) {
    return day2 != null && (this.isBefore(day2) || this.isSameDay(day2));
  }

  /// Checa se é a mesma data, sem verificar as horas
  bool isSameDay(DateTime day2) {
    return day2 != null && this.year == day2.year && this.month == day2.month && this.day == day2.day;
  }
}
