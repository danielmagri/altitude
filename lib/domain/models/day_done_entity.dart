import 'package:altitude/common/extensions/datetime_extension.dart';

class DayDone {
  DayDone({required this.date, this.habitId});

  final String? habitId;
  final DateTime date;

  String get dateFormatted => date.dateFormatted;
}
