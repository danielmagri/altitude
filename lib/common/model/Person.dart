import 'package:altitude/common/controllers/LevelControl.dart';

class Person {
  String uid;

  String name;
  String email;

  int score;
  int level;
  String fcmToken;
  String photoUrl;
  int reminderCounter;

  List<String> friends;
  List<String> pendingFriends;

  bool you;
  int state; // 0-null 1-Amigo 2-Amigo pendente 3-Solicitação

  static const UID = "uid";
  static const NAME = "display_name";
  static const EMAIL = "email";
  static const SCORE = "score";
  static const LEVEL = "level";
  static const FCM_TOKEN = "fcm_token";
  static const REMINDER_COUNTER = "reminder_counter";
  static const FRIENDS = "friends";
  static const PENDING_FRIENDS = "pending_friends";
  static const STATE = "state";

  Person(
      {this.uid,
      this.name,
      this.email,
      this.score,
      this.level,
      this.fcmToken,
      this.photoUrl,
      this.reminderCounter,
      this.friends,
      this.pendingFriends,
      this.you,
      this.state}) {
    if (you == null) you = false;
    if (state == null) state = 0;
  }

  String get levelText => score == null ? "" : LevelControl.getLevelText(score);

  factory Person.fromJson(Map<String, dynamic> json, [String id]) => Person(
      uid: id ?? json[UID],
      name: json[NAME],
      email: json[EMAIL],
      fcmToken: json[FCM_TOKEN],
      score: json[SCORE],
      reminderCounter: json[REMINDER_COUNTER] ?? 0,
      friends: List<String>.from(json[FRIENDS] ?? List()),
      pendingFriends: List<String>.from(json[PENDING_FRIENDS] ?? List()),
      level: json[LEVEL],
      state: json[STATE]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    if (uid != null) map.putIfAbsent(UID, () => uid);
    if (name != null) map.putIfAbsent(NAME, () => name);
    if (email != null) map.putIfAbsent(EMAIL, () => email);
    if (score != null) map.putIfAbsent(SCORE, () => score);
    if (fcmToken != null) map.putIfAbsent(FCM_TOKEN, () => fcmToken);

    return map;
  }
}
