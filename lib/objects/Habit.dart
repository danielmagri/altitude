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
      category: json["Categoria"],
      cue: json["DeixaText"],
      habit: json["HabitoText"],
      reward: json["RecompensaText"],
      score: json["Pontuacao"]);

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Categoria": category,
    "DeixaText": cue,
    "HabitoText": habit,
    "RecompensaText": reward,
    "Pontuacao": score,
  };
}
