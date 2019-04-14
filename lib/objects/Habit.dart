import 'package:habit/utils/enums.dart';

class Habit {
  int id;
  int category;
  String cue;
  String habit;
  String reward;
  int score;

  Habit({this.id, this.category, this.cue, this.habit, this.reward, this.score});

  factory Habit.fromJson(Map<String, dynamic> json) => new Habit(
      id: json["id"],
      category: json["category"],
      cue: json["cue_text"],
      habit: json["habit_text"],
      reward: json["reward_text"],
      score: json["score"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "cue_text": cue,
    "habit_text": habit,
    "reward_text": reward,
    "score": score,
  };
}
