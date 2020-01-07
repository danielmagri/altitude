import 'dart:collection';

class Competitor {
  String uid;
  String name;
  String fcmToken;
  int color;
  int score;
  bool you;

  static const UID = "uid";
  static const NAME = "display_name";
  static const FCM_TOKEN = "fcm_token";
  static const COLOR = "color";
  static const SCORE = "score";
  static const YOU = "you";

  Competitor({
    this.uid,
    this.name,
    this.fcmToken,
    this.color,
    this.score,
    this.you,
  }) {
    if (you == null) you = false;
    if (score == null) score = 0;
  }
  factory Competitor.fromJson(LinkedHashMap<dynamic, dynamic> json) =>
      new Competitor(
        uid: json[UID],
        name: json[NAME],
        fcmToken: json[FCM_TOKEN],
        color: json[COLOR],
        score: json[SCORE],
        you: json[YOU],
      );
}