import 'package:altitude/domain/enums/frquency_type.dart';

abstract class Frequency {
  int? daysCount();
  String frequencyText();
  FrequencyType frequencyType();
  Map<String, dynamic> toJson();

  Frequency();

  factory Frequency.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('days_time')) {
      return Weekly(daysTime: json['days_time']);
    } else {
      return DayWeek(
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

  factory Frequency.fromBD(Map<String, dynamic> json) {
    if (json.containsKey('days_time')) {
      return Weekly(daysTime: json['days_time']);
    } else {
      return DayWeek(
        monday: json['monday'] == 0 ? false : true,
        tuesday: json['tuesday'] == 0 ? false : true,
        wednesday: json['wednesday'] == 0 ? false : true,
        thursday: json['thursday'] == 0 ? false : true,
        friday: json['friday'] == 0 ? false : true,
        saturday: json['saturday'] == 0 ? false : true,
        sunday: json['sunday'] == 0 ? false : true,
      );
    }
  }
}

class DayWeek extends Frequency {
  bool? monday, tuesday, wednesday, thursday, friday, saturday, sunday;

  DayWeek(
      {this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday});

  @override
  int daysCount() {
    int days = 0;

    if (monday!) days++;
    if (tuesday!) days++;
    if (wednesday!) days++;
    if (thursday!) days++;
    if (friday!) days++;
    if (saturday!) days++;
    if (sunday!) days++;

    return days;
  }

  @override
  String frequencyText() {
    String text = '';
    bool hasOne = false;
    int count = daysCount();

    if (monday!) {
      text += 'Segunda';
      hasOne = true;
      count--;
    }
    if (tuesday!) {
      text += _frequencyTextSeparator(hasOne, count);
      text += 'Terça';
      hasOne = true;
      count--;
    }
    if (wednesday!) {
      text += _frequencyTextSeparator(hasOne, count);
      text += 'Quarta';
      hasOne = true;
      count--;
    }
    if (thursday!) {
      text += _frequencyTextSeparator(hasOne, count);
      text += 'Quinta';
      hasOne = true;
      count--;
    }
    if (friday!) {
      text += _frequencyTextSeparator(hasOne, count);
      text += 'Sexta';
      hasOne = true;
      count--;
    }
    if (saturday!) {
      text += _frequencyTextSeparator(hasOne, count);
      text += 'Sábado';
      hasOne = true;
      count--;
    }
    if (sunday!) {
      text += _frequencyTextSeparator(hasOne, count);
      text += 'Domingo';
    }
    return text;
  }

  String _frequencyTextSeparator(bool hasOne, int count) {
    if (hasOne) {
      if (count == 1) {
        return ' e ';
      } else {
        return ', ';
      }
    }
    return '';
  }

  bool isADoneDay(DateTime day) {
    if (monday! && day.weekday == 1) return true;
    if (tuesday! && day.weekday == 2) return true;
    if (wednesday! && day.weekday == 3) return true;
    if (thursday! && day.weekday == 4) return true;
    if (friday! && day.weekday == 5) return true;
    if (saturday! && day.weekday == 6) return true;
    if (sunday! && day.weekday == 7) return true;

    return false;
  }

  @override
  FrequencyType frequencyType() => FrequencyType.dayweek;

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

class Weekly extends Frequency {
  int? daysTime;

  Weekly({this.daysTime});

  @override
  int? daysCount() => daysTime;

  @override
  String frequencyText() {
    if (daysCount() == 1) {
      return '1 vez por semana';
    } else {
      return daysCount().toString() + ' vezes por semana';
    }
  }

  @override
  FrequencyType frequencyType() => FrequencyType.weekly;

  @override
  Map<String, dynamic> toJson() => {
        'days_time': daysTime,
      };
}
