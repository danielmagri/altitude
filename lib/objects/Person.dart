import 'package:habit/controllers/LevelControl.dart';

class Person {
  String name;
  int score;

  Person({
    this.name,
    this.score,
  });

  factory Person.fromJson(Map<String, dynamic> json) =>
      new Person(name: json["id"], score: json["color"]);

  String getLevelText() {
    return LevelControl.getLevelText(score);
  }
}
