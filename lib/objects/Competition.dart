import 'dart:collection';
import 'package:habit/objects/Competitor.dart';

class Competition {
  String id;
  String title;
  List<Competitor> competitors;

  static const ID = "id";
  static const TITLE = "title";
  static const COMPETITORS = "competitors";

  Competition({
    this.id,
    this.title,
    this.competitors,
  });

  factory Competition.fromLinkedJson(LinkedHashMap<dynamic, dynamic> json) {
    return new Competition(
      id: json[ID],
      title: json[TITLE],
      competitors:
      (json[COMPETITORS] as List).map((c) => Competitor.fromJson(c)).toList(),
    );
  }

  factory Competition.fromMapJson(Map<dynamic, dynamic> json) =>
      new Competition(
        id: json[ID],
        title: json[TITLE],
        competitors: json[COMPETITORS],
      );
}
