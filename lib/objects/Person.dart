import 'package:habit/controllers/LevelControl.dart';

class Person {
  String name;
  String email;
  String fcmToken;
  int score;
  List<String> friends;
  List<String> pendingFriends;

  static const NAME = "display_name";
  static const EMAIL = "email";
  static const FCM_TOKEN = "fcm_token";
  static const SCORE = "score";

  Person(
      {this.name,
      this.email,
      this.fcmToken,
      this.score,
      this.friends,
      this.pendingFriends});

  factory Person.fromJson(Map<String, dynamic> json) => new Person(
      name: json[NAME],
      email: json[EMAIL],
      fcmToken: json[FCM_TOKEN],
      score: json[SCORE]);

  String getLevelText() {
    return LevelControl.getLevelText(score);
  }

  Map<String, dynamic> toJson()  {
    Map<String, dynamic> map = new Map();

    if (name != null)
      map.putIfAbsent(NAME, () => name);
    if (email != null)
      map.putIfAbsent(EMAIL, () => email);
    if (score != null)
      map.putIfAbsent(SCORE, () => score);

    return map;
  }
}
