import 'package:altitude/common/constant/level_utils.dart';

class Person {
  Person({
    required this.uid,
    required this.name,
    required this.email,
    required this.score,
    required this.fcmToken,
    required this.friends,
    required this.pendingFriends,
    this.photoUrl,
    int? level,
    int? reminderCounter,
    bool? you,
    int? state,
  })  : you = you ?? false,
        state = state ?? 0,
        reminderCounter = reminderCounter ?? 0,
        level = level ?? LevelUtils.getLevel(score);

  String uid;

  String name;
  String email;

  int score;
  int level;
  String fcmToken;
  String? photoUrl;
  int reminderCounter;

  List<String> friends;
  List<String> pendingFriends;

  bool you;
  int state; // 0-null 1-Amigo 2-Amigo pendente 3-Solicitação

  String get levelText => LevelUtils.getLevelText(score);
}
