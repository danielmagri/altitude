import 'package:altitude/domain/models/competitor_entity.dart';

class CompetitorModel extends Competitor {
  CompetitorModel({
    required String uid,
    required String name,
    required String fcmToken,
    required String habitId,
    required int color,
    int? score,
  }) : super(
          uid: uid,
          name: name,
          fcmToken: fcmToken,
          habitId: habitId,
          color: color,
          score: score,
        );

  factory CompetitorModel.fromJson(Map<dynamic, dynamic> json, String uid) =>
      CompetitorModel(
        uid: uid,
        name: json[nameTag],
        fcmToken: json[fcmTokenTag],
        habitId: json[habitIdTag],
        color: json[colorTag],
        score: json[scoreTag],
      );

  factory CompetitorModel.fromEntity(Competitor competitor) => CompetitorModel(
        uid: competitor.uid,
        name: competitor.name,
        fcmToken: competitor.fcmToken,
        habitId: competitor.habitId,
        color: competitor.color,
      );

  static const nameTag = 'display_name';
  static const fcmTokenTag = 'fcm_token';
  static const habitIdTag = 'habit_id';
  static const colorTag = 'color';
  static const scoreTag = 'score';

  Map<String, dynamic> toJson() => {
        nameTag: name,
        fcmTokenTag: fcmToken,
        habitIdTag: habitId,
        colorTag: color,
        if (you) scoreTag: score
      };
}
