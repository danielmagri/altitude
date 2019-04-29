import 'package:habit/utils/enums.dart';

class Habit {
  final int id;
  final Category category;
  final String cue;
  final String habit;
  final String reward;
  final int score;
  final int cycle;
  final DateTime initialDate;
  final int daysDone;

  Habit(
      {this.id,
      this.category,
      this.cue,
      this.habit,
      this.reward,
      this.score,
      this.cycle,
      this.initialDate,
      this.daysDone});

  factory Habit.fromJson(Map<String, dynamic> json) => new Habit(
      id: json["id"],
      category: Category.values[json["category"]],
      cue: json["cue_text"],
      habit: json["habit_text"],
      reward: json["reward_text"],
      score: json["score"],
      cycle: json["cycle"],
      initialDate: json.containsKey("initial_date") && json["initial_date"] != null
          ? DateTime.parse(json["initial_date"])
          : null,
      daysDone: json["days_done"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category.index,
        "cue_text": cue,
        "habit_text": habit,
        "reward_text": reward,
        "score": score,
        "cycle": cycle,
        "initial_date":
            '${initialDate.year.toString()}-${initialDate.month.toString().padLeft(2, '0')}-${initialDate.day.toString().padLeft(2, '0')}',
        "days_done": daysDone
      };
}
