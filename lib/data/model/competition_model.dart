import 'package:altitude/common/model/Competitor.dart';
import 'package:altitude/domain/models/competition_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompetitionModel extends Competition {
  CompetitionModel({
    required String id,
    required String title,
    required DateTime initialDate,
    required List<Competitor> competitors,
    List<String>? invitations,
  }) : super(
          id: id,
          title: title,
          initialDate: initialDate,
          competitors: competitors,
          invitations: invitations,
        );

  factory CompetitionModel.fromJson(Map<String, dynamic> json, String id) {
    List<Competitor> competitorsList = [];
    if (json[competitorsTag] is Map) {
      final map = json[competitorsTag];
      competitorsList =
          map.keys.map((e) => Competitor.fromJson(map[e], e)).toList();
    }
    return CompetitionModel(
      id: id,
      title: json[titleTag] ?? '',
      initialDate: json[initialDateTag] is Timestamp
          ? DateTime.fromMillisecondsSinceEpoch(
              (json[initialDateTag] as Timestamp).millisecondsSinceEpoch,
            )
          : DateTime.fromMillisecondsSinceEpoch(json[initialDateTag]),
      competitors: competitorsList,
    );
  }

  factory CompetitionModel.fromEntity(Competition competition) =>
      CompetitionModel(
        id: competition.id,
        title: competition.title,
        initialDate: competition.initialDate,
        competitors: competition.competitors,
        invitations: competition.invitations,
      );

  static const idTag = 'id';
  static const titleTag = 'title';
  static const initialDateTag = 'initial_date';
  static const competitorsIdTag = 'competitors_id';
  static const competitorsTag = 'competitors';
  static const invitationsTag = 'invitations';

  Map<String, dynamic> toJson() => {
        titleTag: title,
        initialDateTag: initialDate,
        competitorsIdTag: competitors.map((e) => e.uid).toList(),
        competitorsTag: {for (var e in competitors) e.uid: e.toJson()},
        invitationsTag: invitations
      };
}
