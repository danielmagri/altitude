import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/core/services/FireAuth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Competition {
  String id;
  String title;
  DateTime initialDate;
  List<Competitor> competitors;
  List<String> invitations;

  static const ID = "id";
  static const TITLE = "title";
  static const INITIAL_DATE = "initial_date";
  static const COMPETITORS_ID = "competitors_id";
  static const COMPETITORS = "competitors";
  static const INVITATIONS = "invitations";

  Competition({this.id, this.title, this.initialDate, this.competitors, this.invitations}) {
    if (competitors.isNotEmpty) {
      competitors.sort((a, b) => b.score.compareTo(a.score));
    }
  }

  Competitor getMyCompetitor() => competitors.firstWhere((element) => element.uid == FireAuth().getUid());

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

  factory Competition.fromJson(Map<String, dynamic> json, String id) {
    List<Competitor> competitorsList = [];
    if (json[COMPETITORS] is Map) {
      Map map = json[COMPETITORS] as Map;
      competitorsList = map.keys.map((e) => Competitor.fromJson(map[e], e)).toList();
    }
    return Competition(
        id: id,
        title: json[TITLE],
        initialDate: json[INITIAL_DATE] is Timestamp
            ? DateTime.fromMillisecondsSinceEpoch((json[INITIAL_DATE] as Timestamp).millisecondsSinceEpoch)
            : DateTime.fromMillisecondsSinceEpoch(json[INITIAL_DATE]),
        competitors: competitorsList);
  }

  Map<String, dynamic> toJson() => {
        TITLE: title,
        INITIAL_DATE: initialDate,
        COMPETITORS_ID: competitors.map((e) => e.uid).toList(),
        COMPETITORS: Map.fromIterable(competitors, key: (e) => e.uid, value: (e) => e.toJson()),
        INVITATIONS: invitations
      };
}
