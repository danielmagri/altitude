import 'dart:ui' show Color;
import 'package:altitude/utils/Color.dart';

class HabitStatisticData {
  HabitStatisticData(this.id, this._value, this.habit, this._color, this._totalScore);

  final String id;
  final int _color;
  final int _value;
  final String habit;
  final int _totalScore;

  bool selected = false;

  Color get habitColor => AppColors.habitsColor[_color];
  double get porcentage => (_value / _totalScore) * 100.0;
}
