import 'package:altitude/domain/models/person_entity.dart';

class PersonModel extends Person {
  PersonModel({
    required String name,
    required String email,
    required int score,
    required String fcmToken,
    required List<String> friends,
    required List<String> pendingFriends,
    int? level,
    String? uid,
    int? reminderCounter,
    int? state,
  }) : super(
          uid: uid ?? '',
          name: name,
          email: email,
          score: score,
          level: level,
          fcmToken: fcmToken,
          friends: friends,
          pendingFriends: pendingFriends,
          reminderCounter: reminderCounter,
          state: state,
        );

  factory PersonModel.fromJson(Map<String, dynamic> json, [String? id]) =>
      PersonModel(
        uid: id ?? json[uidTag],
        name: json[nameTag],
        email: json[emailTag],
        fcmToken: json[fcmTokenTag],
        score: json[scoreTag],
        reminderCounter: json[reminderCounterTag] ?? 0,
        friends: List<String>.from(json[friendsTag] ?? []),
        pendingFriends: List<String>.from(json[pendingFriendsTag] ?? []),
        state: json[stateTag],
      );

  static const uidTag = 'uid';
  static const nameTag = 'display_name';
  static const emailTag = 'email';
  static const scoreTag = 'score';
  static const levelTag = 'level';
  static const fcmTokenTag = 'fcm_token';
  static const reminderCounterTag = 'reminder_counter';
  static const friendsTag = 'friends';
  static const pendingFriendsTag = 'pending_friends';
  static const stateTag = 'state';

  Map<String, dynamic> toJson() => {
        uidTag: uid,
        nameTag: name,
        emailTag: email,
        fcmTokenTag: fcmToken,
        levelTag: level,
        reminderCounterTag: reminderCounter,
        scoreTag: score,
        friendsTag: friends,
        pendingFriendsTag: pendingFriends
      };
}
