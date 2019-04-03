import 'package:habit/utils/enums.dart';

class Habit {
  Category category;
  String _cue;
  String _habit;
  String _reward;
  int score;

  Habit(Category category, String cue, String habit, String reward, int score) {
    this.category = category;
    this._cue = cue;
    this._habit = habit;
    this._reward = reward;
    this.score = score;
  }

  String getCueText() {
    return _cue;
  }

  String getHabitText() {
    return _habit;
  }

  String getRewardText() {
    return _reward;
  }
}