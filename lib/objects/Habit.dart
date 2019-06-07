class Habit {
  int score;
  int daysDone;
  final int id;
  final int color;
  final int icon;
  final String cue;
  final String habit;
  final int cycle;
  final DateTime initialDate;

  Habit(
      {this.id, this.color, this.icon, this.cue, this.habit, this.score, this.cycle, this.initialDate, this.daysDone});

  factory Habit.fromJson(Map<String, dynamic> json) => new Habit(
      id: json["id"],
      color: json["color"],
      icon: json["icon"],
      cue: json["cue_text"],
      habit: json["habit_text"],
      score: json["score"],
      cycle: json["cycle"],
      initialDate: json.containsKey("initial_date") && json["initial_date"] != null
          ? DateTime.parse(json["initial_date"])
          : null,
      daysDone: json["days_done"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "color": color,
        "icon": icon,
        "cue_text": cue,
        "habit_text": habit,
        "score": score,
        "cycle": cycle,
        "initial_date":
            '${initialDate.year.toString()}-${initialDate.month.toString().padLeft(2, '0')}-${initialDate.day.toString().padLeft(2, '0')}',
        "days_done": daysDone
      };
}
