import 'dart:collection';
import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/core/services/FireAuth.dart';

class Competition {
  String id;
  String title;
  DateTime initialDate;
  List<Competitor> competitors;

  static const ID = "id";
  static const TITLE = "title";
  static const INITIAL_DATE = "initial_date";
  static const COMPETITORS_ID = "competitors_id";
  static const COMPETITORS = "competitors";

  Competition({
    this.id,
    this.title,
    this.initialDate,
    this.competitors,
  }) {
    if (competitors.isNotEmpty) {
      competitors.sort((a, b) => b.score.compareTo(a.score));
    }
  }

  int getHabitColor() {
    return competitors.firstWhere((element) => element.uid == FireAuth().getUid()).color ?? 0;
  }

  String listCompetitors() {
    String list = "";

    if (competitors != null) {
      for (var i = 0; i < competitors.length; i++) {
        list += competitors[i].name;
        if (i < competitors.length - 1) {
          list += ", ";
        }
      }
    }

    return list;
  }

  @deprecated
  factory Competition.fromLinkedJson(LinkedHashMap<dynamic, dynamic> json) {
    return new Competition(
      id: json[ID],
      title: json[TITLE],
      initialDate: json[INITIAL_DATE] == null ? null : new DateTime.fromMillisecondsSinceEpoch(json[INITIAL_DATE]),
      competitors: (json[COMPETITORS] as List).map((c) => Competitor.fromJson(c)).toList(),
    );
  }

  factory Competition.fromJson(Map<String, dynamic> json, String id) => Competition(
      id: id,
      title: json[TITLE],
      initialDate: json[INITIAL_DATE] == null ? null : new DateTime.fromMillisecondsSinceEpoch(json[INITIAL_DATE]),
      competitors: json[COMPETITORS]);

  Map<String, dynamic> toJson() => {
    TITLE: title,
    INITIAL_DATE: initialDate,
    COMPETITORS_ID: competitors.map((e) => e.uid).toList(),
    COMPETITORS: competitors.map((e) => e.toJson()).toList()
  };
}
