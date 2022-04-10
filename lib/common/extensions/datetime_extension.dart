import 'package:altitude/common/constant/constants.dart';

extension DateTimeExtension on DateTime {
  /// Retorna somente o date do `DateTime`
  DateTime get onlyDate {
    return DateTime.utc(year, month, day);
  }

  String get dateFormatted {
    return '${year.toString()}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  /// Retorna o último dia da semana
  DateTime lastWeekDay() {
    int days = weekday == 7 ? lastWeekday : lastWeekday - weekday;
    return add(Duration(days: days));
  }

  /// Retorna o último dia do mês anterior
  DateTime lastDayOfPreviousMonth() {
    return DateTime(year, month).subtract(const Duration(days: 1));
  }

  bool isAfterOrSameDay(DateTime? day2) {
    return day2 != null && (isAfter(day2) || isSameDay(day2));
  }

  bool isBeforeOrSameDay(DateTime? day2) {
    return day2 != null && (isBefore(day2) || isSameDay(day2));
  }

  /// Checa se é a mesma data, sem verificar as horas
  bool isSameDay(DateTime? day2) {
    return day2 != null &&
        year == day2.year &&
        month == day2.month &&
        day == day2.day;
  }
}
