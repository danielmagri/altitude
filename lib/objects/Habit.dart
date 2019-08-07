class Habit {
  int id;
  int score;
  int color;
  String cue;
  String habit;
  DateTime initialDate;
  int daysDone;

  Habit(
      {this.id,
      this.color,
      this.cue,
      this.habit,
      this.score,
      this.initialDate,
      this.daysDone});

  factory Habit.fromJson(Map<String, dynamic> json) => new Habit(
      id: json["id"],
      color: json["color"],
      cue: json["cue_text"],
      habit: json["habit_text"],
      score: json["score"],
      initialDate:
          json.containsKey("initial_date") && json["initial_date"] != null
              ? DateTime.parse(json["initial_date"])
              : null,
      daysDone: json["days_done"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "color": color,
        "cue_text": cue,
        "habit_text": habit,
        "score": score,
        "initial_date":
            '${initialDate.year.toString()}-${initialDate.month.toString().padLeft(2, '0')}-${initialDate.day.toString().padLeft(2, '0')}',
        "days_done": daysDone
      };
}
