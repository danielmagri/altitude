import 'package:altitude/core/services/interfaces/i_fire_auth.dart';
import 'package:get_it/get_it.dart';

class Competitor {
  final String uid;
  final String name;
  final String fcmToken;

  final String habitId;
  int color;
  int score;

  bool you;

  static const NAME = "display_name";
  static const FCM_TOKEN = "fcm_token";
  static const HABIT_ID = "habit_id";
  static const COLOR = "color";
  static const SCORE = "score";

  Competitor({this.uid, this.name, this.fcmToken, this.habitId, this.color, this.score, this.you}) {
    this.you = you ?? GetIt.I.get<IFireAuth>().getUid() == uid;
    this.score = score ?? 0;
  }

  factory Competitor.fromJson(Map<dynamic, dynamic> json, String uid) => Competitor(
      uid: uid,
      name: json[NAME],
      fcmToken: json[FCM_TOKEN],
      habitId: json[HABIT_ID],
      color: json[COLOR],
      score: json[SCORE]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent(NAME, () => name);
    map.putIfAbsent(FCM_TOKEN, () => fcmToken);
    map.putIfAbsent(HABIT_ID, () => habitId);
    map.putIfAbsent(COLOR, () => color);
    if (you) map.putIfAbsent(SCORE, () => score);
    return map;
  }
}
