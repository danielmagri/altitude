import 'dart:collection';

class Competitor {
  String uid;
  String name;
  int color;
  int score;
  bool you;

  static const UID = "uid";
  static const NAME = "display_name";
  static const COLOR = "color";
  static const SCORE = "score";
  static const YOU = "you";

  Competitor({
    this.uid,
    this.name,
    this.color,
    this.score,
    this.you,
  }) {
    if (you == null) you = false;
  }
  factory Competitor.fromJson(LinkedHashMap<dynamic, dynamic> json) =>
      new Competitor(
        uid: json[UID],
        name: json[NAME],
        color: json[COLOR],
        score: json[SCORE],
        you: json[YOU],
      );
}