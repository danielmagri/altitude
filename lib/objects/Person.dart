class Person {
  final String name;
  int score;

  Person({this.name, this.score});

  factory Person.fromJson(Map<String, dynamic> json) => new Person(name: json["full_name"], score: json["score"]);

  Map<String, dynamic> toJson() => {
        "full_name": name,
        "score": score,
      };
}
