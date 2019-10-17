import 'dart:collection';

class Competitor {
  String name;
  int color;
  int score;
  bool you;

  static const NAME = "display_name";
  static const COLOR = "color";
  static const SCORE = "score";

  Competitor({
    this.name,
    this.color,
    this.score,
    this.you,
  }) {
    if (you == null) you = false;
  }
  factory Competitor.fromJson(LinkedHashMap<dynamic, dynamic> json) =>
      new Competitor(
        name: json[NAME],
        color: json[COLOR],
        score: json[SCORE],
      );
}