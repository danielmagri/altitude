import 'dart:ui' show Color;

import 'package:altitude/common/sharedPref/SharedPref.dart';
import 'package:altitude/utils/Color.dart';

class HabitStatisticData {
  HabitStatisticData(this.id, this._value, this.habit, this._color);

  final int id;
  final int _color;
  final int _value;
  final String habit;

  bool selected = false;

  Color get habitColor => AppColors.habitsColor[_color];
  double get porcentage => (_value / SharedPref.instance.score) * 100.0;
}
