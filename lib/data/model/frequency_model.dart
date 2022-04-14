import 'package:altitude/common/model/failure.dart';
import 'package:altitude/domain/models/frequency_entity.dart';

abstract class FrequencyModel extends Frequency {
  factory FrequencyModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('days_time')) {
      return WeeklyModel(daysTime: json['days_time']);
    } else {
      return DayWeekModel(
        monday: json['monday'],
        tuesday: json['tuesday'],
        wednesday: json['wednesday'],
        thursday: json['thursday'],
        friday: json['friday'],
        saturday: json['saturday'],
        sunday: json['sunday'],
      );
    }
  }

  factory FrequencyModel.fromEntity(Frequency entity) {
    if (entity is DayWeek) {
      return DayWeekModel(
        monday: entity.monday,
        tuesday: entity.tuesday,
        wednesday: entity.wednesday,
        thursday: entity.thursday,
        friday: entity.friday,
        saturday: entity.saturday,
        sunday: entity.sunday,
      );
    } else if (entity is Weekly) {
      return WeeklyModel(daysTime: entity.daysTime);
    } else {
      throw Failure.dataFailure('FrequencyModel.fromEntity');
    }
  }

  Map<String, dynamic> toJson();
}

class DayWeekModel extends DayWeek implements FrequencyModel {
  DayWeekModel({
    required bool monday,
    required bool tuesday,
    required bool wednesday,
    required bool thursday,
    required bool friday,
    required bool saturday,
    required bool sunday,
  }) : super(
          monday: monday,
          tuesday: tuesday,
          wednesday: wednesday,
          thursday: thursday,
          friday: friday,
          saturday: saturday,
          sunday: sunday,
        );

  @override
  Map<String, dynamic> toJson() => {
        'monday': monday,
        'tuesday': tuesday,
        'wednesday': wednesday,
        'thursday': thursday,
        'friday': friday,
        'saturday': saturday,
        'sunday': sunday,
      };
}

class WeeklyModel extends Weekly implements FrequencyModel {
  WeeklyModel({required int daysTime}) : super(daysTime: daysTime);

  @override
  Map<String, dynamic> toJson() => {
        'days_time': daysTime,
      };
}
