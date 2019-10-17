import 'dart:collection';
import 'package:habit/objects/Competitor.dart';

class Competition {
  String title;
  List<Competitor> competitors;

  static const TITLE = "title";
  static const COMPETITORS = "competitors";

  Competition({
    this.title,
    this.competitors,
  });

  factory Competition.fromJson(LinkedHashMap<dynamic, dynamic> json) =>
      new Competition(
        title: json[TITLE],
        competitors: json[COMPETITORS],
      );
}
