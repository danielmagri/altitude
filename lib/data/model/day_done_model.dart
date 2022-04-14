import 'package:altitude/common/extensions/datetime_extension.dart';
import 'package:altitude/domain/models/day_done_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DayDoneModel extends DayDone {
  DayDoneModel({required DateTime date, String? habitId})
      : super(habitId: habitId, date: date);

  factory DayDoneModel.fromJson(Map<String, dynamic> json) => DayDoneModel(
        date: DateTime.fromMillisecondsSinceEpoch(
          (json[dateTag] as Timestamp).millisecondsSinceEpoch,
        ).onlyDate,
      );

  factory DayDoneModel.fromEntity(DayDone entity) => DayDoneModel(
        date: entity.date,
        habitId: entity.habitId,
      );

  static const dateTag = 'date';

  Map<String, dynamic> toJson() => {dateTag: date};
}
