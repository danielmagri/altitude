class CompetitionPresentation {
  String id;
  String title;
  int score;
  int color;

  CompetitionPresentation({
    this.id,
    this.title,
    this.score,
    this.color,
  });

  factory CompetitionPresentation.fromMapJson(Map<dynamic, dynamic> json) =>
      new CompetitionPresentation(
        id: json["id"],
        title: json["title"],
        score: json["score"],
        color: json["color"],
      );
}
