import 'package:altitude/domain/models/reminder_entity.dart';

class ReminderModel extends Reminder {
  ReminderModel({
    required int type,
    required int hour,
    required int minute,
    required bool monday,
    required bool tuesday,
    required bool wednesday,
    required bool thursday,
    required bool friday,
    required bool saturday,
    required bool sunday,
    int? id,
  }) : super(
          type: type,
          hour: hour,
          minute: minute,
          id: id,
          monday: monday,
          tuesday: tuesday,
          wednesday: wednesday,
          thursday: thursday,
          friday: friday,
          saturday: saturday,
          sunday: sunday,
        );

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
        id: json[idTag],
        type: json[typeTag],
        hour: json[hourTag],
        minute: json[minuteTag],
        monday: json[mondayTag],
        tuesday: json[tuesdayTag],
        wednesday: json[wednesdayTag],
        thursday: json[thursdayTag],
        friday: json[fridayTag],
        saturday: json[saturdayTag],
        sunday: json[sundayTag],
      );

  factory ReminderModel.fromEntity(Reminder entity) => ReminderModel(
        type: entity.type,
        hour: entity.hour,
        minute: entity.minute,
        id: entity.id,
        monday: entity.monday,
        tuesday: entity.tuesday,
        wednesday: entity.wednesday,
        thursday: entity.thursday,
        friday: entity.friday,
        saturday: entity.saturday,
        sunday: entity.sunday,
      );

  static const idTag = 'id';
  static const typeTag = 'type';
  static const hourTag = 'hour';
  static const minuteTag = 'minute';
  static const mondayTag = 'monday';
  static const tuesdayTag = 'tuesday';
  static const wednesdayTag = 'wednesday';
  static const thursdayTag = 'thursday';
  static const fridayTag = 'friday';
  static const saturdayTag = 'saturday';
  static const sundayTag = 'sunday';

  Map<String, dynamic> toJson() => {
        idTag: id,
        typeTag: type,
        hourTag: hour,
        minuteTag: minute,
        mondayTag: monday,
        tuesdayTag: tuesday,
        wednesdayTag: wednesday,
        thursdayTag: thursday,
        fridayTag: friday,
        saturdayTag: saturday,
        sundayTag: sunday,
      };
}
