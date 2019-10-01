import 'dart:collection';
import 'package:habit/controllers/LevelControl.dart';

class Person {
  String uid;
  String name;
  String email;
  String fcmToken;
  int score;
  List<String> friends;
  List<String> pendingFriends;
  bool you;

  static const UID = "uid";
  static const NAME = "display_name";
  static const EMAIL = "email";
  static const FCM_TOKEN = "fcm_token";
  static const SCORE = "score";

  Person(
      {this.uid,
      this.name,
      this.email,
      this.fcmToken,
      this.score,
      this.friends,
      this.pendingFriends,
      this.you}) {
    if (you == null) you = false;
  }

  factory Person.fromJson(LinkedHashMap<dynamic, dynamic> json) => new Person(
        uid: json[UID],
        name: json[NAME],
        email: json[EMAIL],
        fcmToken: json[FCM_TOKEN],
        score: json[SCORE],
        you: false,
      );

  String getLevelText() {
    if (score == null) return "";
    return LevelControl.getLevelText(score);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = new Map();

    if (name != null) map.putIfAbsent(NAME, () => name);
    if (email != null) map.putIfAbsent(EMAIL, () => email);
    if (score != null) map.putIfAbsent(SCORE, () => score);

    return map;
  }
}
